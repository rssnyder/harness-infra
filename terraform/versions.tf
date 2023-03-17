terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    harness = {
      source  = "harness/harness"
      version = "0.14.11"
    }
    # harness-ccm = {
    #   source  = "harness.io/ccm/harness-ccm"
    #   version = "3.0.1"
    # }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      owner = "riley.snyder@harness.io"
      ttl   = "-1"
    }
  }
}

# provider "harness-ccm" {
#   account_identifier = "wlgELJ0TTre5aZhzpt8gVA"
# }