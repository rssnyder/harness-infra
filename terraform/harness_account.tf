resource "harness_platform_connector_github" "Github" {
  identifier      = "Github"
  name            = "Github"
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


resource "harness_platform_triggers" "dailytest" {
  identifier = "dailytest"
  org_id     = "default"
  project_id = "Default_Project_1662659562703"
  name       = "newname"
  target_id  = "dronegithubapp"
  yaml       = <<-EOT
trigger:
  name: newname
  identifier: dailytest
  enabled: true
  orgIdentifier: default
  projectIdentifier: Default_Project_1662659562703
  pipelineIdentifier: dronegithubapp
  source:
    type: Scheduled
    spec:
      type: Cron
      spec:
        expression: 0 2 * * *
  inputYaml: |
    pipeline:
      identifier: dronegithubapp
      properties:
        ci:
          codebase:
            build:
              type: branch
              spec:
                branch: main

    EOT
}