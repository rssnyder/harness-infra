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
  source              = "github.com/rssnyder/terraform-aws-harness-ccm.git"
  external_id         = "harness:891928451355:wlgELJ0TTre5aZhzpt8gVA"
  enable_events       = true
  enable_optimization = true
  prefix              = "riley-"
}
