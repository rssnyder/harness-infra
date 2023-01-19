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

module "ccm" {
  source  = "harness-community/harness-ccm/aws"
  version = "0.0.3"
  # source                  = "../../terraform-aws-harness-ccm"
  external_id             = "harness:891928451355:wlgELJ0TTre5aZhzpt8gVA"
  additional_external_ids = ["harness:891928451355:V2iSB2gRR_SxBs0Ov5vqCQ"]
  enable_events           = true
  enable_optimization     = true
  enable_governance       = true
  governance_policy_arn   = aws_iam_policy.delegate_aws_access.arn
  prefix                  = "riley-"
  secrets = [
    "arn:aws:secretsmanager:us-west-2:759984737373:secret:sa/ca-key.pem-HYlaV4",
    "arn:aws:secretsmanager:us-west-2:759984737373:secret:sa/ca-cert.pem-kq8HQl"
  ]
}

resource "aws_ecr_repository" "rileysnyder" {
  name = "rileysnyder"
}
