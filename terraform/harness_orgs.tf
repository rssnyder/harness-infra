module "snyder" {
  source = "github.com/harness-community/terraform-harness-modules/organizations"

  name        = "snyder"
  description = "Harness Core Management Organization"
  tags = {
    purpose = "harness-management"
  }
  global_tags = var.global_tags
}

module "snyder-management" {
  source = "github.com/harness-community/terraform-harness-modules/projects"

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
  source = "github.com/harness-community/terraform-harness-modules/organizations"

  name        = "williams"
  description = "Harness Core Management Organization"
  tags = {
    purpose = "harness-management"
  }
  global_tags = var.global_tags
}

module "williams-management" {
  source = "github.com/harness-community/terraform-harness-modules/projects"

  name            = "management"
  organization_id = module.williams.organization_details.id
  color           = "#83A38C"
  description     = "Project to support Harness Management Pipelines"
  tags = {
    role = "platform-management"
  }
  global_tags = var.global_tags
}