terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    harness = {
      source  = "harness/harness"
      version = "0.30.8"
    }
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

provider "azurerm" {
  features {}
}

provider "harness" {}
