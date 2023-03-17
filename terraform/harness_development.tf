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
    namespace: riley-${harness_platform_environment.development_dev.id}-<+service.name.toLowerCase()>
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
    namespace: riley-${harness_platform_environment.development_stage.id}-<+service.name.toLowerCase()>
    releaseName: release-<+INFRA_KEY>
  allowSimultaneousDeployments: false
EOF
}

resource "harness_platform_service" "fargate-delegate" {
  identifier = "fargatedelegate"
  name       = "fargate-delegate"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  yaml       = <<EOF
service:
  name: fargate-delegate
  identifier: fargatedelegate
  serviceDefinition:
    type: ECS
    spec:
      manifests:
        - manifest:
            identifier: task
            type: EcsTaskDefinition
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - delegate_task.json
                  repoName: rssnyder/template
                  branch: main
        - manifest:
            identifier: service
            type: EcsServiceDefinition
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - delegate_service.json
                  repoName: rssnyder/template
                  branch: main
      artifacts:
        primary:
          primaryArtifactRef: <+input>
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: rssnyder/delegate
                tag: 23.01.78101
              identifier: delegate
              type: DockerRegistry
      variables:
        - name: cpu
          type: String
          description: ""
          value: "1024"
        - name: memory
          type: String
          description: ""
          value: "2048"
        - name: delegate_name
          type: String
          description: ""
          value: ecstest
        - name: manager_host_and_port
          type: String
          description: ""
          value: https://app.harness.io/gratis
        - name: log_streaming_Service_url
          type: String
          description: ""
          value: https://app.harness.io/gratis/log-service/
        - name: role
          type: String
          description: ""
          value: arn:aws:iam::759984737373:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS
        - name: subnet
          type: String
          description: ""
          value: subnet-0974d4940eab1ea9d
        - name: security_group
          type: String
          description: ""
          value: sg-0472e18c1a90179d9
  gitOpsEnabled: false
EOF
}