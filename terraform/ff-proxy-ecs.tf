# module "ff-proxy-ecs" {
#   source               = "../../feature-flag-relay-proxy-ecs"
#   name                 = "hrns-ff-proxy"
#   image                = "harness/ff-proxy:2.0.0-rc.24"
#   proxy_key_secret_arn = "arn:aws:secretsmanager:us-west-2:759984737373:secret:riley/ff-proxy-key-EHPGoR"

#   vpc_id = data.aws_vpc.sa-lab.id

#   proxy_subnets = data.aws_subnets.sa-lab-private.ids
#   alb_subnets   = data.aws_subnets.sa-lab-public.ids

#   tags = {
#     "app" : "hrns-ff-proxy-rssnyder"
#   }
# }

# output "proxy_url" {
#   value = module.ff-proxy-ecs.proxy_url
# }
