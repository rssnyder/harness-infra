module "ccm" {
  # source  = "harness-community/harness-ccm/aws"
  # version = "0.1.6"

  source = "../../terraform-aws-harness-ccm"

  # source = "git::https://github.com/rssnyder/terraform-aws-harness-ccm?ref=fix/lambda-exe-kms"

  s3_bucket_arn = "arn:aws:s3:::harness-solutions-architecture"
  external_id   = "harness:891928451355:wlgELJ0TTre5aZhzpt8gVA"
  additional_external_ids = [
    "harness:891928451355:V2iSB2gRR_SxBs0Ov5vqCQ"
  ]
  enable_billing          = true
  enable_events           = true
  enable_optimization     = false
  enable_governance       = false
  enable_commitment_read  = false
  enable_commitment_write = false

  enable_cmk_ebs                     = false
  enable_autostopping_elb            = true
  enable_autostopping_ec2            = true
  enable_autostopping_asg_rds_lambda = true

  governance_policy_arns = [
    aws_iam_policy.governance-tagging.arn,
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  prefix = "riley-"
  secrets = [
    "arn:aws:secretsmanager:us-west-2:759984737373:secret:sa/ca-key.pem-HYlaV4",
    "arn:aws:secretsmanager:us-west-2:759984737373:secret:sa/ca-cert.pem-kq8HQl"
  ]
}

# module "ccmtest" {
#   source  = "harness-community/harness-ccm/aws"
#   version = "0.1.5-beta.1"

#   # source = "../../terraform-aws-harness-ccm"

#   external_id         = "harness:891928451355:wlgELJ0TTre5aZhzpt8gVA"
#   enable_events       = true
#   enable_optimization = true
#   enable_governance   = true
#   governance_policy_arns = [
#     aws_iam_policy.delegate_aws_access.arn
#   ]
#   prefix = "rileyccmtestmodule-"
# }

resource "harness_platform_connector_awscc" "rileyharnessccm" {
  identifier = "rileyharnessccm"
  name       = "riley-harness-ccm"

  account_id  = "759984737373"
  report_name = "solutions-architecture"
  s3_bucket   = "harness-solutions-architecture"
  features_enabled = [
    "OPTIMIZATION",
    "VISIBILITY",
    "BILLING",
    "GOVERNANCE"
  ]
  cross_account_access {
    role_arn    = module.ccm.cross_account_role
    external_id = module.ccm.external_id
  }
}

resource "harness_platform_connector_azure_cloud_cost" "azure-sales-ccm" {
  identifier = "azuresalesccm"
  name       = "azure-sales-ccm"

  features_enabled = ["BILLING", "VISIBILITY", "OPTIMIZATION"]
  tenant_id        = "b229b2bb-5f33-4d22-bce0-730f6474e906"
  subscription_id  = "e8389fc5-0cb8-44ab-947b-c6cf62552be0"
  billing_export_spec {
    storage_account_name = "rileysnyderharnessio"
    container_name       = "ccm"
    directory_name       = "export"
    report_name          = "rileysnyderharnessccm"
    subscription_id      = "e8389fc5-0cb8-44ab-947b-c6cf62552be0"
  }
}

resource "harness_platform_connector_azure_cloud_cost" "azure-sales-ccm-broken" {
  identifier = "azuresalesccmbroken"
  name       = "azure-sales-ccm-broken"

  features_enabled = ["VISIBILITY", "OPTIMIZATION"]
  tenant_id        = "b229b2bb-5f33-4d22-bce0-730f6474e906"
  subscription_id  = "e8389fc5-0cb8-44ab-947b-c6cf62552be1"
}

# resource "harness_platform_connector_awscc" "rileyharnessccmbroken" {
#   identifier = "rileyharnessccmbroken"
#   name       = "riley-harness-ccm-broken"

#   account_id = "759984737374"
#   features_enabled = [
#     "OPTIMIZATION",
#     "VISIBILITY",
#   ]
#   cross_account_access {
#     role_arn    = "arn:aws:iam::759984737374:role/riley-HarnessCERole"
#     external_id = "harness:891928451355:wlgELJ0TTre5aZhzpt8gVA"
#   }
# }

resource "harness_platform_connector_gcp_cloud_cost" "gcpccm" {
  identifier = "gcpccm"
  name       = "gcp-ccm"

  features_enabled      = ["BILLING", "VISIBILITY", "OPTIMIZATION"]
  gcp_project_id        = "sales-209522"
  service_account_email = "harness-ce-wlgel-78524@ce-prod-274307.iam.gserviceaccount.com"
  billing_export_spec {
    data_set_id = "data_set_id"
    table_id    = "table_id"
  }
}

resource "harness_platform_connector_gcp_cloud_cost" "gcpccmbroken" {
  identifier = "gcpccmbroken"
  name       = "gcp-ccm-broken"

  features_enabled      = ["VISIBILITY", "OPTIMIZATION"]
  gcp_project_id        = "example-proj-234"
  service_account_email = "harness-ce-wlgel-78524@ce-prod-274307.iam.gserviceaccount.com"
}
