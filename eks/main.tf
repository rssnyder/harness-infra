data "aws_region" "current" {}
data "harness_platform_current_account" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "rssnyder"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = data.aws_vpc.sa-lab.id
  subnet_ids = data.aws_subnets.sa-lab-private.ids

  enable_irsa = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]

      min_size     = 2
      max_size     = 5
      desired_size = 2
    }
  }
}

resource "aws_eks_access_policy_association" "sso_cluster_admin" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::759984737373:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSPowerUserAccess_c9634c1cd159b7c2"

  access_scope {
    type = "cluster"
  }
}

data "aws_iam_policy_document" "sales_eks" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        module.eks.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values = [
        "system:serviceaccount:harness-delegate-ng:sales-eks"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "sales_eks" {
  name                 = "sales_eks"
  assume_role_policy   = data.aws_iam_policy_document.sales_eks.json
  max_session_duration = 28800
}

resource "aws_iam_role_policy_attachment" "sales_eks" {
  role       = aws_iam_role.sales_eks.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "sales_eks_assumed" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.sales_eks.arn
      ]
    }
  }
}

resource "aws_iam_role" "sales_eks_assumed" {
  name                 = "sales_eks_assumed"
  assume_role_policy   = data.aws_iam_policy_document.sales_eks_assumed.json
  max_session_duration = 28800
}

resource "aws_iam_role_policy_attachment" "sales_eks_assumed" {
  role       = aws_iam_role.sales_eks_assumed.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "null_resource" "kubeconfig" {
  depends_on = [module.eks]

  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${data.aws_region.current.name} --name ${module.eks.cluster_name}"
  }
}

locals {
  values = {
    delegateName        = "home"
    accountId           = data.harness_platform_current_account.current.account_id
    delegateToken       = var.delegate_token
    managerEndpoint     = "https://app.harness.io/gratis"
    delegateDockerImage = "harness/delegate:24.01.82202"
    replicas            = 1
    cpu                 = "100m"
    serviceAccountAnnotations = {
      "eks.amazonaws.com/role-arn" : "arn:aws:iam::759984737373:role/sales_eks"
    }
  }
}

resource "helm_release" "harness-delegate-ng" {
  depends_on = [null_resource.kubeconfig]

  name       = "harness-delegate-ng"
  repository = "https://app.harness.io/storage/harness-download/delegate-helm-chart"
  chart      = "harness-delegate-ng"

  values = [yamlencode(local.values)]
}

resource "harness_platform_connector_kubernetes" "sales_eks" {
  identifier = "sales_eks"
  name       = "sales_eks"

  inherit_from_delegate {
    delegate_selectors = ["sales-eks"]
  }
}

resource "harness_platform_connector_aws" "sales_eks_aws" {
  identifier = "sales_eks_aws"
  name       = "sales_eks_aws"

  irsa {
    delegate_selectors = [
      "sales-eks"
    ]
    region = "us-west-2"
  }
}

resource "harness_platform_connector_aws" "sales_eks_aws_assumed" {
  identifier = "sales_eks_aws_assumed"
  name       = "sales_eks_aws_assumed"

  inherit_from_delegate {
    delegate_selectors = [
      "sales-eks"
    ]
    region = "us-west-2"
  }
  cross_account_access {
    role_arn = aws_iam_role.sales_eks_assumed.arn
  }
}

