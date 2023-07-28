data "harness_current_account" "current" {}

resource "harness_platform_connector_github" "Github" {
  identifier          = "Github"
  name                = "Github"
  url                 = "https://github.com"
  connection_type     = "Account"
  validation_repo     = "rssnyder/test"
  execute_on_delegate = false

  api_authentication {
    token_ref = "account.gh_pat"
  }

  credentials {
    http {
      username  = "rssnyder"
      token_ref = "account.gh_pat"
    }
  }
}

resource "harness_platform_connector_docker" "dockerhub" {
  identifier = "dockerhub"
  name       = "dockerhub"
  type       = "DockerHub"
  url        = "https://index.docker.io/v2/"

  credentials {
    username     = "rssnyder"
    password_ref = "account.dockerhub"
  }
}

resource "harness_platform_connector_aws" "sales" {
  identifier = "sales"
  name       = "sales"

  cross_account_access {
    role_arn = aws_iam_role.rileysnyderharnessio-assumed.arn
  }

  inherit_from_delegate {
    delegate_selectors = [
      "ecs"
    ]
  }
}

resource "harness_platform_connector_kubernetes" "sagcp" {
  identifier = "sagcp"
  name       = "sagcp"

  inherit_from_delegate {
    delegate_selectors = ["sa-cluster"]
  }
}

resource "harness_platform_connector_docker" "harness" {
  identifier = "harness_images"
  name       = "harness images"
  type       = "Other"
  url        = "https://app.harness.io/registry"
}

# resource "harness_platform_user" "proxy" {
#   email       = "rileysndrproxy@harness.io"
#   user_groups = ["_account_all_users"]
#   role_bindings {
#     role_identifier           = "_account_viewer"
#     role_name                 = "Account Viewer"
#     resource_group_name       = "All Resources Including Child Scopes"
#     resource_group_identifier = "_all_resources_including_child_scopes"
#     managed_role              = true
#   }
# }


resource "harness_platform_connector_github" "temp" {
  identifier      = "temp"
  name            = "temp"
  url             = "https://github.com"
  connection_type = "Account"
  validation_repo = "rssnyder/test"

  api_authentication {
    token_ref = "account.gh_pat"
  }

  credentials {
    http {
      username  = "rssnyder"
      token_ref = "account.gh_pat"
    }
  }
}