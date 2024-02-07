# resource "aws_iam_policy" "sa-eks-additional" {
#   name = "sa-eks-additional"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:Describe*",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = "sa"
#   cluster_version = "1.29"

#   cluster_endpoint_public_access = true

#   cluster_addons = {
#     kube-proxy = {}
#     vpc-cni    = {}
#     coredns = {
#       configuration_values = jsonencode({
#         computeType = "Fargate"
#       })
#     }
#   }

#   vpc_id     = data.aws_vpc.sa-lab.id
#   subnet_ids = data.aws_subnets.sa-lab-private.ids
#   #   control_plane_subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

#   create_cluster_security_group = false
#   create_node_security_group    = false

#   fargate_profile_defaults = {
#     iam_role_additional_policies = {
#       additional = aws_iam_policy.sa-eks-additional.arn
#     }
#   }

#   tags = {
#     Team = "sa"
#   }
# }