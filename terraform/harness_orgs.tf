module "snyder" {
  source = "git@github.com:harness-community/terraform-harness-modules.git//organizations"

  name        = "snyder"
  description = "Harness Core Management Organization"
  tags = {
    purpose = "harness-management"
  }
  global_tags = var.global_tags
}

module "snyder-management" {
  source = "git@github.com:harness-community/terraform-harness-modules.git//projects"

  name            = "management"
  organization_id = module.snyder.organization_details.id
  color           = "#83A38C"
  description     = "Project to support Harness Management Pipelines"
  tags = {
    role = "platform-management"
  }
  global_tags = var.global_tags
}

module "williams" {
  source = "git@github.com:harness-community/terraform-harness-modules.git//organizations"

  name        = "williams"
  description = "Harness Core Management Organization"
  tags = {
    purpose = "harness-management"
  }
  global_tags = var.global_tags
}
