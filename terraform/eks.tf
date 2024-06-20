# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = "sa"
#   cluster_version = "1.29"

#   cluster_endpoint_public_access = true

#   cluster_addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {}
#     kube-proxy             = {}
#     vpc-cni                = {}
#   }

#   vpc_id     = data.aws_vpc.sa-lab.id
#   subnet_ids = data.aws_subnets.sa-lab-private.ids

#   enable_irsa = true

#   enable_cluster_creator_admin_permissions = true

#   eks_managed_node_groups = {
#     example = {
#       ami_type       = "AL2_x86_64"
#       instance_types = ["t3.medium"]

#       min_size     = 2
#       max_size     = 5
#       desired_size = 2
#     }
#   }
# }

# data "aws_iam_policy_document" "sa_eks" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type = "Federated"
#       identifiers = [
#         module.eks.oidc_provider_arn
#       ]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${module.eks.oidc_provider}:sub"
#       values = [
#         "system:serviceaccount:harness-delegate-ng:sa-eks"
#       ]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${module.eks.oidc_provider}:aud"
#       values = [
#         "sts.amazonaws.com"
#       ]
#     }
#   }
# }

# resource "aws_iam_role" "sa_eks" {
#   name                 = "sa_eks"
#   assume_role_policy   = data.aws_iam_policy_document.sa_eks.json
#   max_session_duration = 28800
# }

# resource "aws_iam_role_policy_attachment" "sa_eks" {
#   role       = aws_iam_role.sa_eks.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

# data "aws_iam_policy_document" "sa_eks_assumed" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type = "AWS"
#       identifiers = [
#         aws_iam_role.sa_eks.arn
#       ]
#     }
#   }
# }

# resource "aws_iam_role" "sa_eks_assumed" {
#   name                 = "sa_eks_assumed"
#   assume_role_policy   = data.aws_iam_policy_document.sa_eks_assumed.json
#   max_session_duration = 28800
# }

# resource "aws_iam_role_policy_attachment" "sa_eks_assumed" {
#   role       = aws_iam_role.sa_eks_assumed.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

# resource "harness_platform_connector_kubernetes" "sa_eks" {
#   identifier = "sa_eks"
#   name       = "sa_eks"

#   inherit_from_delegate {
#     delegate_selectors = ["sa-eks"]
#   }
# }

# resource "harness_platform_connector_aws" "sa_eks_aws" {
#   identifier = "sa_eks_aws"
#   name       = "sa_eks_aws"

#   irsa {
#     delegate_selectors = [
#       "sa-eks"
#     ]
#     region = "us-west-2"
#   }
# }

# resource "harness_platform_connector_aws" "sa_eks_aws_assumed" {
#   identifier = "sa_eks_aws_assumed"
#   name       = "sa_eks_aws_assumed"

#   inherit_from_delegate {
#     delegate_selectors = [
#       "sa-eks"
#     ]
#     region = "us-west-2"
#   }
#   cross_account_access {
#     role_arn = aws_iam_role.sa_eks_assumed.arn
#   }
# }

