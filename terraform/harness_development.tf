resource "harness_platform_project" "development" {
  identifier = "development"
  name       = "development"
  org_id     = data.harness_platform_organization.default.id
}

resource "harness_platform_usergroup" "approvers" {
  identifier         = "approvers"
  name               = "approvers"
  org_id             = data.harness_platform_organization.default.id
  project_id         = harness_platform_project.development.id
  externally_managed = false
  users = [
    "4JCQs46YTxKawHSWVW6nLA"
  ]
  notification_configs {
    type        = "EMAIL"
    group_email = "riley.snyder@harness.io"
  }
}

resource "harness_platform_connector_prometheus" "saprom" {
  identifier         = "saprom"
  name               = "sa-prom"
  url                = "http://prometheus-kube-prometheus-prometheus.prometheus.svc.cluster.local:9090/"
  delegate_selectors = ["riley-sa-gcp"]
}

resource "harness_platform_connector_artifactory" "harnessartifactory" {
  identifier = "harnessartifactory"
  name       = "harness-artifactory"
  url        = "https://harness.jfrog.io/artifactory/"
}

resource "harness_platform_environment" "development_dev" {
  identifier = "dev"
  name       = "dev"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  type       = "PreProduction"
  yaml       = <<EOF
environment:
  name: dev
  identifier: dev
  description: ""
  tags: {}
  type: PreProduction
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  variables: []
EOF
}

resource "harness_platform_infrastructure" "development_dev_sa" {
  identifier      = harness_platform_connector_kubernetes.sagcp.id
  name            = harness_platform_connector_kubernetes.sagcp.id
  org_id          = data.harness_platform_organization.default.id
  project_id      = harness_platform_project.development.id
  env_id          = harness_platform_environment.development_dev.id
  type            = "KubernetesDirect"
  deployment_type = "Kubernetes"
  yaml            = <<EOF
infrastructureDefinition:
  name: ${harness_platform_connector_kubernetes.sagcp.id}
  identifier: ${harness_platform_connector_kubernetes.sagcp.id}
  description: ""
  tags: {}
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  environmentRef: ${harness_platform_environment.dev.id}
  deploymentType: Kubernetes
  type: KubernetesDirect
  spec:
    connectorRef: account.${harness_platform_connector_kubernetes.sagcp.id}
    namespace: riley-${harness_platform_environment.development_dev.id}-<+service.name>
    releaseName: release-<+INFRA_KEY>
  allowSimultaneousDeployments: false
EOF
}

resource "harness_platform_environment" "development_stage" {
  identifier = "stage"
  name       = "stage"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  type       = "PreProduction"
  yaml       = <<EOF
environment:
  name: stage
  identifier: stage
  description: ""
  tags: {}
  type: PreProduction
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  variables: []
EOF
}

resource "harness_platform_infrastructure" "development_stage_sa" {
  identifier      = "sa"
  name            = "sa"
  org_id          = data.harness_platform_organization.default.id
  project_id      = harness_platform_project.development.id
  env_id          = harness_platform_environment.development_stage.id
  type            = "KubernetesDirect"
  deployment_type = "Kubernetes"
  yaml            = <<EOF
infrastructureDefinition:
  name: sa
  identifier: sa
  description: ""
  tags: {}
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  environmentRef: ${harness_platform_environment.development_stage.id}
  deploymentType: Kubernetes
  type: KubernetesDirect
  spec:
    connectorRef: account.sagcp
    namespace: riley-${harness_platform_environment.development_stage.id}-<+service.name>
    releaseName: release-<+INFRA_KEY>
  allowSimultaneousDeployments: false
EOF
}
