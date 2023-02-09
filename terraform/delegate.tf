resource "aws_iam_policy" "delegate_aws_access" {
  name        = "delegate_aws_access"
  description = "Policy for harness delegate aws access"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "GetArtifacts",
           "Effect": "Allow",
           "Action": [
               "s3:*"
           ],
           "Resource": [
              "${aws_s3_bucket.riley-snyder-harness-io.arn}",
              "${aws_s3_bucket.riley-snyder-harness-io.arn}/*"
           ]
       },
       {
           "Sid": "DockerLogin",
           "Effect": "Allow",
           "Action": "secretsmanager:GetSecretValue",
           "Resource": "arn:aws:secretsmanager:us-west-2:759984737373:secret:riley/dockerhub*"
       },
       {
           "Sid": "AssumeAdmin",
           "Effect": "Allow",
           "Action": "sts:AssumeRole",
           "Resource": "${aws_iam_role.rileysnyderharnessio-assumed.arn}"
       }
   ]
}
EOF
}

module "delegate" {
  source = "git::https://github.com/harness-community/terraform-aws-harness-delegate-ecs-fargate.git?ref=0.0.10"
  # source                    = "../../terraform-aws-harness-delegate-ecs-fargate"
  name                      = "ecs"
  harness_account_id        = "wlgELJ0TTre5aZhzpt8gVA"
  delegate_image            = "rssnyder/delegate:latest"
  delegate_token_secret_arn = "arn:aws:secretsmanager:us-west-2:759984737373:secret:riley/delegate-zBsttc"
  registry_secret_arn       = "arn:aws:secretsmanager:us-west-2:759984737373:secret:riley/dockerhub-UiTqT3"
  runner_config             = file("${path.module}/pool.yml")
  init_script               = "curl -o- -L https://slss.io/install | bash && mv /opt/harness-delegate/.serverless/bin/serverless /usr/local/bin/"
  delegate_environment = [
    {
      name  = "RUNNER_URL",
      value = "https://ip-10-0-1-35.us-west-2.compute.internal:3000"
    }
  ]
  delegate_tags = "linux-amd64"
  delegate_policy_arns = [
    aws_iam_policy.delegate_aws_access.arn,
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
  security_groups = [
    module.vpc.default_security_group_id
  ]
  subnets = module.vpc.private_subnets
}

# module "delegate-fallback" {
#   source = "git::https://github.com/rssnyder/terraform-aws-harness-delegate-ecs-fargate.git?ref=0.0.4"
#   #   source                    = "../../terraform-aws-harness-delegate-ecs-fargate"
#   name                      = "ecs-fallback"
#   harness_account_id        = "wlgELJ0TTre5aZhzpt8gVA"
#   delegate_token_secret_arn = "arn:aws:secretsmanager:us-west-2:759984737373:secret:riley/delegate-zBsttc"
#   delegate_policy_arn       = aws_iam_policy.delegate_aws_access.arn
#   security_groups = [
#     module.vpc.default_security_group_id
#   ]
#   subnets    = module.vpc.private_subnets
#   cluster_id = module.delegate.aws_ecs_cluster
# }

# module "ecs-schedule" {
#   source = "git::https://github.com/rssnyder/terraform-aws-ecs-scheduler.git?ref=0.0.1"
#   #   source = "../../terraform-aws-ecs-scheduler"
#   prefix = "rileysnyder_"
#   services = [
#     {
#       cluster_arn = module.delegate.aws_ecs_cluster,
#       service_arn = module.delegate.aws_ecs_service,
#       start_cron  = "cron(0 13 ? * MON-FRI *)",
#       stop_cron   = "cron(0 21 ? * MON-FRI *)"
#     },
#     # {
#     #   cluster_arn = module.delegate-fallback.aws_ecs_cluster,
#     #   service_arn = module.delegate-fallback.aws_ecs_service,
#     #   start_cron  = "cron(0 13 ? * MON-FRI *)",
#     #   #   stop_cron   = "cron(0 21 ? * MON-FRI *)"
#     #   stop_cron = "cron(38 19 ? * MON-FRI *)"
#     # }
#   ]
# }


