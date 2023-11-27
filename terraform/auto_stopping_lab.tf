resource "harness_platform_project" "auto_stopping_lab" {
  identifier = "auto_stopping_lab"
  name       = "auto stopping lab"
  org_id     = data.harness_platform_organization.default.id
}

resource "harness_platform_workspace" "aws_ec2" {
  name                    = "aws ec2"
  identifier              = "aws_ec2"
  org_id                  = data.harness_platform_organization.default.id
  project_id              = harness_platform_project.auto_stopping_lab.id
  provisioner_type        = "terraform"
  provisioner_version     = "1.5.6"
  repository              = "wings-software/AutoStoppingLab"
  repository_branch       = "chore/ec2-enhancements"
  repository_path         = "aws/ec2"
  cost_estimation_enabled = true

  # github connector that can resolve repo above
  provider_connector   = "account.${harness_platform_connector_github.Github.id}"
  repository_connector = "account.${harness_platform_connector_github.Github.id}"

  # Inputs
  terraform_variable {
    key        = "name"
    value      = "snyderiacmec2"
    value_type = "string"
  }
  terraform_variable {
    key        = "harness_cloud_connector_id"
    value      = "rileyharnessccm"
    value_type = "string"
  }

  # Harness Auth
  environment_variable {
    key        = "HARNESS_ACCOUNT_ID"
    value      = "wlgELJ0TTre5aZhzpt8gVA"
    value_type = "string"
  }
  environment_variable {
    key        = "HARNESS_PLATFORM_API_KEY"
    value      = "account.harness_api_token"
    value_type = "secret"
  }

  # AWS Auth
  environment_variable {
    key        = "AWS_DEFAULT_REGION"
    value      = "us-west-2"
    value_type = "string"
  }
  environment_variable {
    key        = "AWS_ACCESS_KEY_ID"
    value      = "AWS_ACCESS_KEY_ID"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SECRET_ACCESS_KEY"
    value      = "AWS_SECRET_ACCESS_KEY"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SESSION_TOKEN"
    value      = "AWS_SESSION_TOKEN"
    value_type = "secret"
  }
}

resource "harness_platform_workspace" "aws_proxy" {
  name                    = "aws proxy"
  identifier              = "aws_proxy"
  org_id                  = data.harness_platform_organization.default.id
  project_id              = harness_platform_project.auto_stopping_lab.id
  provisioner_type        = "terraform"
  provisioner_version     = "1.5.6"
  repository              = "wings-software/AutoStoppingLab"
  repository_branch       = "chore/ec2-proxy-enhance"
  repository_path         = "aws/proxy"
  cost_estimation_enabled = true

  # github connector that can resolve repo above
  provider_connector   = "account.${harness_platform_connector_github.Github.id}"
  repository_connector = "account.${harness_platform_connector_github.Github.id}"

  # Inputs
  terraform_variable {
    key        = "name"
    value      = "snyderiacmproxy"
    value_type = "string"
  }
  terraform_variable {
    key        = "harness_cloud_connector_id"
    value      = "rileyharnessccm"
    value_type = "string"
  }
  terraform_variable {
    key        = "harness_proxy_api_key"
    value      = "account.harness_api_token"
    value_type = "secret"
  }

  # Harness Auth
  environment_variable {
    key        = "HARNESS_ACCOUNT_ID"
    value      = "wlgELJ0TTre5aZhzpt8gVA"
    value_type = "string"
  }
  environment_variable {
    key        = "HARNESS_PLATFORM_API_KEY"
    value      = "account.harness_api_token"
    value_type = "secret"
  }

  # AWS Auth
  environment_variable {
    key        = "AWS_DEFAULT_REGION"
    value      = "us-west-2"
    value_type = "string"
  }
  environment_variable {
    key        = "AWS_ACCESS_KEY_ID"
    value      = "AWS_ACCESS_KEY_ID"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SECRET_ACCESS_KEY"
    value      = "AWS_SECRET_ACCESS_KEY"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SESSION_TOKEN"
    value      = "AWS_SESSION_TOKEN"
    value_type = "secret"
  }
}

# THIS REQUIRES YOU APPLY harness_platform_workspace.aws_proxy
resource "harness_platform_workspace" "aws_ec2_proxy" {
  name                    = "aws ec2 proxy"
  identifier              = "aws_ec2_proxy"
  org_id                  = data.harness_platform_organization.default.id
  project_id              = harness_platform_project.auto_stopping_lab.id
  provisioner_type        = "terraform"
  provisioner_version     = "1.5.6"
  repository              = "wings-software/AutoStoppingLab"
  repository_branch       = "chore/ec2-proxy-enhance"
  repository_path         = "aws/ec2-with-proxy"
  cost_estimation_enabled = true

  # github connector that can resolve repo above
  provider_connector   = "account.${harness_platform_connector_github.Github.id}"
  repository_connector = "account.${harness_platform_connector_github.Github.id}"

  # Inputs
  terraform_variable {
    key        = "name"
    value      = "snyderiacmec2proxy"
    value_type = "string"
  }
  terraform_variable {
    key        = "harness_cloud_connector_id"
    value      = "rileyharnessccm"
    value_type = "string"
  }
  terraform_variable {
    key        = "proxy_id"
    value      = "ap-clig9e7h9gljadhv47eg"
    value_type = "string"
  }
  terraform_variable {
    key        = "proxy_public_ip"
    value      = "54.218.21.151"
    value_type = "string"
  }

  # Harness Auth
  environment_variable {
    key        = "HARNESS_ACCOUNT_ID"
    value      = "wlgELJ0TTre5aZhzpt8gVA"
    value_type = "string"
  }
  environment_variable {
    key        = "HARNESS_PLATFORM_API_KEY"
    value      = "account.harness_api_token"
    value_type = "secret"
  }

  # AWS Auth
  environment_variable {
    key        = "AWS_DEFAULT_REGION"
    value      = "us-west-2"
    value_type = "string"
  }
  environment_variable {
    key        = "AWS_ACCESS_KEY_ID"
    value      = "AWS_ACCESS_KEY_ID"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SECRET_ACCESS_KEY"
    value      = "AWS_SECRET_ACCESS_KEY"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SESSION_TOKEN"
    value      = "AWS_SESSION_TOKEN"
    value_type = "secret"
  }
}

# THIS REQUIRES YOU APPLY harness_platform_workspace.aws_proxy
resource "harness_platform_workspace" "aws_rds" {
  name                    = "aws rds"
  identifier              = "aws_rds"
  org_id                  = data.harness_platform_organization.default.id
  project_id              = harness_platform_project.auto_stopping_lab.id
  provisioner_type        = "terraform"
  provisioner_version     = "1.5.6"
  repository              = "wings-software/AutoStoppingLab"
  repository_branch       = "chore/enhance-rds"
  repository_path         = "aws/rds"
  cost_estimation_enabled = true

  # github connector that can resolve repo above
  provider_connector   = "account.${harness_platform_connector_github.Github.id}"
  repository_connector = "account.${harness_platform_connector_github.Github.id}"

  # Inputs
  terraform_variable {
    key        = "name"
    value      = "snyderiacmrds"
    value_type = "string"
  }
  terraform_variable {
    key        = "harness_cloud_connector_id"
    value      = "rileyharnessccm"
    value_type = "string"
  }
  terraform_variable {
    key        = "proxy_id"
    value      = "ap-clig9e7h9gljadhv47eg"
    value_type = "string"
  }

  # Harness Auth
  environment_variable {
    key        = "HARNESS_ACCOUNT_ID"
    value      = "wlgELJ0TTre5aZhzpt8gVA"
    value_type = "string"
  }
  environment_variable {
    key        = "HARNESS_PLATFORM_API_KEY"
    value      = "account.harness_api_token"
    value_type = "secret"
  }

  # AWS Auth
  environment_variable {
    key        = "AWS_DEFAULT_REGION"
    value      = "us-west-2"
    value_type = "string"
  }
  environment_variable {
    key        = "AWS_ACCESS_KEY_ID"
    value      = "AWS_ACCESS_KEY_ID"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SECRET_ACCESS_KEY"
    value      = "AWS_SECRET_ACCESS_KEY"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SESSION_TOKEN"
    value      = "AWS_SESSION_TOKEN"
    value_type = "secret"
  }
}

resource "harness_platform_workspace" "aws_ecs" {
  name                    = "aws ecs"
  identifier              = "aws_ecs"
  org_id                  = data.harness_platform_organization.default.id
  project_id              = harness_platform_project.auto_stopping_lab.id
  provisioner_type        = "terraform"
  provisioner_version     = "1.5.6"
  repository              = "wings-software/AutoStoppingLab"
  repository_branch       = "chore/enhance-ecs"
  repository_path         = "aws/ecs"
  cost_estimation_enabled = true

  # github connector that can resolve repo above
  provider_connector   = "account.${harness_platform_connector_github.Github.id}"
  repository_connector = "account.${harness_platform_connector_github.Github.id}"

  # Inputs
  terraform_variable {
    key        = "name"
    value      = "snyderiacmecs"
    value_type = "string"
  }
  terraform_variable {
    key        = "harness_cloud_connector_id"
    value      = "rileyharnessccm"
    value_type = "string"
  }

  # Harness Auth
  environment_variable {
    key        = "HARNESS_ACCOUNT_ID"
    value      = "wlgELJ0TTre5aZhzpt8gVA"
    value_type = "string"
  }
  environment_variable {
    key        = "HARNESS_PLATFORM_API_KEY"
    value      = "account.harness_api_token"
    value_type = "secret"
  }

  # AWS Auth
  environment_variable {
    key        = "AWS_DEFAULT_REGION"
    value      = "us-west-2"
    value_type = "string"
  }
  environment_variable {
    key        = "AWS_ACCESS_KEY_ID"
    value      = "AWS_ACCESS_KEY_ID"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SECRET_ACCESS_KEY"
    value      = "AWS_SECRET_ACCESS_KEY"
    value_type = "secret"
  }
  environment_variable {
    key        = "AWS_SESSION_TOKEN"
    value      = "AWS_SESSION_TOKEN"
    value_type = "secret"
  }
}
