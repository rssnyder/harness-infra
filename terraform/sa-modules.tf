module "harness-ci-factory" {
  source = "git@github.com:harness-community/solutions-architecture.git//harness-ci-factory?ref=feature/harness-ci-factory"
  # source = "../../solutions-architecture/harness-ci-factory"

  harness_api_key_secret           = "account.harness_api_token"
  organization_name                = module.solution-architecture.details.name
  create_organization              = false
  project_name                     = "harness-ci-factory"
  create_project                   = true
  container_registry               = "registry.rileysnyder.dev"
  container_registry_type          = "docker"
  container_registry_connector_ref = "account.hurley"
  kubernetes_connector_ref         = "account.sagcp"
  kubernetes_namespace             = "riley"
  max_build_concurrency            = 5
  enable_schedule                  = false
  schedule                         = "0 2 * * *"
}

# module "terraform-development-factory" {
#   # source = "git@github.com:harness-community/solutions-architecture.git//terraform-development-factory?ref=enhancement/update-module-source"
#   source = "../../solutions-architecture/terraform-development-factory"

#   organization_name         = module.solution-architecture.details.name
#   create_organization       = false
#   project_name              = "terraform-development-factory"
#   repositories              = ["harness-infra"]
#   terraform_files           = "terraform"
#   harness_api_key_location  = "account"
#   harness_api_key_secret    = "harness_api_token"
#   github_connector_location = "account"
#   github_connector_id       = "rssnyder"
#   github_username           = "rssnyder"
#   github_secret_location    = "account"
#   github_secret_id          = "ghpat"
# }