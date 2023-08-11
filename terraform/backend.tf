# terraform {
#   backend "s3" {
#     bucket = "riley-snyder-harness-io"
#     key    = "terraform/harness-infra"
#     region = "us-west-2"
#   }
# }
# terraform {
#   backend "http" {
#     address  = "https://app.harness.io/gateway/iacm/api/orgs/default/projects/development/workspaces/harnessinfra/terraform-backend?accountIdentifier=wlgELJ0TTre5aZhzpt8gVA"
#     username = "harness"
#     lock_address   = "https://app.harness.io/gateway/iacm/api/orgs/default/projects/development/workspaces/harnessinfra/terraform-backend/lock?accountIdentifier=wlgELJ0TTre5aZhzpt8gVA"
#     lock_method    = "POST"
#     unlock_address = "https://app.harness.io/gateway/iacm/api/orgs/default/projects/development/workspaces/harnessinfra/terraform-backend/lock?accountIdentifier=wlgELJ0TTre5aZhzpt8gVA"
#     unlock_method  = "DELETE"
#   }
# }
