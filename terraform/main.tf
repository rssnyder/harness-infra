data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "riley-snyder-harness-io" {
  bucket = "riley-snyder-harness-io"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "riley-snyder-harness-io" {
  bucket = aws_s3_bucket.riley-snyder-harness-io.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "riley-snyder-harness-io" {
  bucket = aws_s3_bucket.riley-snyder-harness-io.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_ecr_repository" "rileysnyder" {
  name = "rileysnyder"
}

# resource "harness_platform_connector_awscc" "rileyharnessccm" {
#   identifier = "rileyharnessccm"
#   name       = "riley-harness-ccm"

#   account_id  = "759984737373"
#   report_name = "riley-harness-ccm"
#   s3_bucket   = "riley-harness-ccm"
#   features_enabled = [
#     "OPTIMIZATION",
#     "VISIBILITY",
#     "BILLING",
#   ]
#   cross_account_access {
#     role_arn    = "arn:aws:iam::759984737373:role/riley-HarnessCERole"
#     external_id = "harness:891928451355:wlgELJ0TTre5aZhzpt8gVA"
#   }
# }