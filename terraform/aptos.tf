# input sets

## bundles == version manifests

resource "harness_platform_input_set" "bundle0" {
  identifier  = "bundle0"
  name        = "bundle0"
  org_id      = data.harness_platform_organization.default.id
  project_id  = harness_platform_project.development.id
  pipeline_id = harness_platform_pipeline.aptos_demo.id
  yaml        = <<-EOT
inputSet:
  name: bundle0
  tags: {}
  identifier: bundle0
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  pipeline:
    identifier: aptos_demo
    variables:
      - name: serviceA
        type: String
        value: 1.23.3
      - name: serviceB
        type: String
        value: 1.22.1
      - name: serviceC
        type: String
        value: 1.20.0
      - name: serviceD
        type: String
        value: 1.16.0
  EOT
}

resource "harness_platform_input_set" "bundle1" {
  identifier  = "bundle1"
  name        = "bundle1"
  org_id      = data.harness_platform_organization.default.id
  project_id  = harness_platform_project.development.id
  pipeline_id = harness_platform_pipeline.aptos_demo.id
  yaml        = <<-EOT
inputSet:
  name: bundle1
  tags: {}
  identifier: bundle1
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  pipeline:
    identifier: ${harness_platform_pipeline.aptos_demo.id}
    variables:
      - name: serviceA
        type: String
        value: 1.23.3
      - name: serviceB
        type: String
        value: 1.22.1
      - name: serviceC
        type: String
        value: 1.20.0
      - name: serviceD
        type: String
        value: 1.17.0
  EOT
}

resource "harness_platform_input_set" "bundle2" {
  identifier  = "bundle2"
  name        = "bundle2"
  org_id      = data.harness_platform_organization.default.id
  project_id  = harness_platform_project.development.id
  pipeline_id = harness_platform_pipeline.aptos_demo.id
  yaml        = <<-EOT
inputSet:
  name: bundle2
  tags: {}
  identifier: bundle2
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  pipeline:
    identifier: ${harness_platform_pipeline.aptos_demo.id}
    variables:
      - name: serviceA
        type: String
        value: 1.23.0
      - name: serviceB
        type: String
        value: 1.22.0
      - name: serviceC
        type: String
        value: 1.20.1
      - name: serviceD
        type: String
        value: 1.16.1
  EOT
}

## customer === set of services

resource "harness_platform_input_set" "customerA" {
  identifier  = "customerA"
  name        = "customerA"
  org_id      = data.harness_platform_organization.default.id
  project_id  = harness_platform_project.development.id
  pipeline_id = harness_platform_pipeline.aptos_demo.id
  yaml        = <<-EOT
inputSet:
  name: customerA
  tags: {}
  identifier: customerA
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  pipeline:
    identifier: ${harness_platform_pipeline.aptos_demo.id}
    stages:
      - stage:
          identifier: dev
          type: Deployment
          spec:
            services:
              values:
                - serviceRef: serviceA
                  serviceInputs:
                    serviceDefinition:
                      type: Kubernetes
                      spec:
                        variables:
                          - name: version
                            type: String
                            value: "<+pipeline.variables.serviceA>"
                - serviceRef: serviceB
                  serviceInputs:
                    serviceDefinition:
                      type: Kubernetes
                      spec:
                        variables:
                          - name: version
                            type: String
                            value: "<+pipeline.variables.serviceB>"
                - serviceRef: serviceC
                  serviceInputs:
                    serviceDefinition:
                      type: Kubernetes
                      spec:
                        variables:
                          - name: version
                            type: String
                            value: "<+pipeline.variables.serviceC>"
                - serviceRef: serviceD
                  serviceInputs:
                    serviceDefinition:
                      type: Kubernetes
                      spec:
                        variables:
                          - name: version
                            type: String
                            value: "<+pipeline.variables.serviceD>"
  EOT
}

resource "harness_platform_input_set" "customerB" {
  identifier  = "customerB"
  name        = "customerB"
  org_id      = data.harness_platform_organization.default.id
  project_id  = harness_platform_project.development.id
  pipeline_id = harness_platform_pipeline.aptos_demo.id
  yaml        = <<-EOT
inputSet:
  name: customerB
  tags: {}
  identifier: customerB
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  pipeline:
    identifier: ${harness_platform_pipeline.aptos_demo.id}
    stages:
      - stage:
          identifier: dev
          type: Deployment
          spec:
            services:
              values:
                - serviceRef: serviceA
                  serviceInputs:
                    serviceDefinition:
                      type: Kubernetes
                      spec:
                        variables:
                          - name: version
                            type: String
                            value: "<+pipeline.variables.serviceA>"
  EOT
}

resource "harness_platform_input_set" "customerAslim" {
  identifier  = "customerAslim"
  name        = "customerAslim"
  org_id      = data.harness_platform_organization.default.id
  project_id  = harness_platform_project.development.id
  pipeline_id = harness_platform_pipeline.aptos_demo.id
  yaml        = <<-EOT
inputSet:
  name: customerAslim
  tags: {}
  identifier: customerAslim
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  pipeline:
    identifier: ${harness_platform_pipeline.aptos_demo.id}
    stages:
      - stage:
          identifier: dev
          type: Deployment
          spec:
            services:
              values:
                - serviceRef: serviceAslim
                - serviceRef: serviceBslim
                - serviceRef: serviceCslim
                - serviceRef: serviceDslim
  EOT
}

resource "harness_platform_input_set" "customerBslim" {
  identifier  = "customerBslim"
  name        = "customerBslim"
  org_id      = data.harness_platform_organization.default.id
  project_id  = harness_platform_project.development.id
  pipeline_id = harness_platform_pipeline.aptos_demo.id
  yaml        = <<-EOT
inputSet:
  name: customerBslim
  tags: {}
  identifier: customerBslim
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  pipeline:
    identifier: ${harness_platform_pipeline.aptos_demo.id}
    stages:
      - stage:
          identifier: dev
          type: Deployment
          spec:
            services:
              values:
                - serviceRef: serviceAslim
  EOT
}

# pipeline

resource "harness_platform_pipeline" "aptos_demo" {
  identifier = "aptos_demo"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  name       = "aptos_demo"
  yaml       = <<-EOT
pipeline:
  name: aptos_demo
  identifier: aptos_demo
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.development.id}
  tags: {}
  stages:
    - stage:
        name: dev
        identifier: dev
        description: ""
        type: Deployment
        spec:
          deploymentType: Kubernetes
          services:
            values: <+input>
            metadata:
              parallel: true
          environment:
            environmentRef: dev
            deployToAll: false
            infrastructureDefinitions:
              - identifier: sagcp
          execution:
            steps:
              - step:
                  name: create
                  identifier: create
                  template:
                    templateRef: account.create_namespace
                    versionLabel: "1"
              - step:
                  name: Rollout Deployment
                  identifier: rolloutDeployment
                  type: K8sRollingDeploy
                  timeout: 10m
                  spec:
                    skipDryRun: false
                    pruningEnabled: false
              - step:
                  name: delete
                  identifier: delete
                  template:
                    templateRef: account.delete_namespace
                    versionLabel: "1"
            rollbackSteps:
              - step:
                  name: Rollback Rollout Deployment
                  identifier: rollbackRolloutDeployment
                  type: K8sRollingRollback
                  timeout: 10m
                  spec:
                    pruningEnabled: false
        tags: {}
        failureStrategies:
          - onFailure:
              errors:
                - AllErrors
              action:
                type: StageRollback
  variables:
    - name: serviceA
      type: String
      description: ""
      value: <+input>
    - name: serviceB
      type: String
      description: ""
      value: <+input>
    - name: serviceC
      type: String
      description: ""
      value: <+input>
    - name: serviceD
      type: String
      description: ""
      value: <+input>
  EOT
}

# services

resource "harness_platform_service" "serviceA" {
  identifier = "serviceA"
  name       = "serviceA"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  yaml       = <<EOF
service:
  name: serviceA
  identifier: serviceA
  tags: {}
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: template
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - deployment.yaml
                  repoName: rssnyder/template
                  branch: main
              valuesPaths:
                - values.yaml
              skipResourceVersioning: false
      artifacts:
        primary:
          primaryArtifactRef: nginx
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: library/nginx
                tag: <+serviceVariables.version>
              identifier: nginx
              type: DockerRegistry
      variables:
        - name: port
          type: String
          description: ""
          value: "80"
          default: "80"
        - name: replicas
          type: String
          description: ""
          value: "1"
          default: "1"
        - name: version
          type: String
          description: ""
          value: "<+input>"
          default: "1.0.0"
EOF
}

resource "harness_platform_service" "serviceB" {
  identifier = "serviceB"
  name       = "serviceB"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  yaml       = <<EOF
service:
  name: serviceB
  identifier: serviceB
  tags: {}
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: template
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - deployment.yaml
                  repoName: rssnyder/template
                  branch: main
              valuesPaths:
                - values.yaml
              skipResourceVersioning: false
      artifacts:
        primary:
          primaryArtifactRef: nginx
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: library/nginx
                tag: <+serviceVariables.version>
              identifier: nginx
              type: DockerRegistry
      variables:
        - name: port
          type: String
          description: ""
          value: "80"
          default: "80"
        - name: replicas
          type: String
          description: ""
          value: "1"
          default: "1"
        - name: version
          type: String
          description: ""
          value: "<+input>"
          default: "1.0.0"
EOF
}

resource "harness_platform_service" "serviceC" {
  identifier = "serviceC"
  name       = "serviceC"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  yaml       = <<EOF
service:
  name: serviceC
  identifier: serviceC
  tags: {}
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: template
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - deployment.yaml
                  repoName: rssnyder/template
                  branch: main
              valuesPaths:
                - values.yaml
              skipResourceVersioning: false
      artifacts:
        primary:
          primaryArtifactRef: nginx
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: library/nginx
                tag: <+serviceVariables.version>
              identifier: nginx
              type: DockerRegistry
      variables:
        - name: port
          type: String
          description: ""
          value: "80"
          default: "80"
        - name: replicas
          type: String
          description: ""
          value: "1"
          default: "1"
        - name: version
          type: String
          description: ""
          value: "<+input>"
          default: "1.0.0"
EOF
}

resource "harness_platform_service" "serviceD" {
  identifier = "serviceD"
  name       = "serviceD"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  yaml       = <<EOF
service:
  name: serviceD
  identifier: serviceD
  tags: {}
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: template
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - deployment.yaml
                  repoName: rssnyder/template
                  branch: main
              valuesPaths:
                - values.yaml
              skipResourceVersioning: false
      artifacts:
        primary:
          primaryArtifactRef: nginx
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: library/nginx
                tag: <+serviceVariables.version>
              identifier: nginx
              type: DockerRegistry
      variables:
        - name: port
          type: String
          description: ""
          value: "80"
          default: "80"
        - name: replicas
          type: String
          description: ""
          value: "1"
          default: "1"
        - name: version
          type: String
          description: ""
          value: "<+input>"
          default: "1.0.0"
EOF
}

resource "harness_platform_service" "serviceAslim" {
  identifier = "serviceAslim"
  name       = "serviceAslim"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  yaml       = <<EOF
service:
  name: serviceAslim
  identifier: serviceAslim
  tags: {}
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: template
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - deployment.yaml
                  repoName: rssnyder/template
                  branch: main
              valuesPaths:
                - values.yaml
              skipResourceVersioning: false
      artifacts:
        primary:
          primaryArtifactRef: nginx
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: library/nginx
                tag: <+serviceVariables.version>
              identifier: nginx
              type: DockerRegistry
      variables:
        - name: port
          type: String
          description: ""
          value: "80"
          default: "80"
        - name: replicas
          type: String
          description: ""
          value: "1"
          default: "1"
        - name: version
          type: String
          description: ""
          value: "<+pipeline.variables.serviceA>"
          default: "1.0.0"
EOF
}

resource "harness_platform_service" "serviceBslim" {
  identifier = "serviceBslim"
  name       = "serviceBslim"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  yaml       = <<EOF
service:
  name: serviceBslim
  identifier: serviceBslim
  tags: {}
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: template
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - deployment.yaml
                  repoName: rssnyder/template
                  branch: main
              valuesPaths:
                - values.yaml
              skipResourceVersioning: false
      artifacts:
        primary:
          primaryArtifactRef: nginx
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: library/nginx
                tag: <+serviceVariables.version>
              identifier: nginx
              type: DockerRegistry
      variables:
        - name: port
          type: String
          description: ""
          value: "80"
          default: "80"
        - name: replicas
          type: String
          description: ""
          value: "1"
          default: "1"
        - name: version
          type: String
          description: ""
          value: "<+pipeline.variables.serviceA>"
          default: "1.0.0"
EOF
}

resource "harness_platform_service" "serviceCslim" {
  identifier = "serviceCslim"
  name       = "serviceCslim"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  yaml       = <<EOF
service:
  name: serviceCslim
  identifier: serviceCslim
  tags: {}
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: template
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - deployment.yaml
                  repoName: rssnyder/template
                  branch: main
              valuesPaths:
                - values.yaml
              skipResourceVersioning: false
      artifacts:
        primary:
          primaryArtifactRef: nginx
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: library/nginx
                tag: <+serviceVariables.version>
              identifier: nginx
              type: DockerRegistry
      variables:
        - name: port
          type: String
          description: ""
          value: "80"
          default: "80"
        - name: replicas
          type: String
          description: ""
          value: "1"
          default: "1"
        - name: version
          type: String
          description: ""
          value: "<+pipeline.variables.serviceA>"
          default: "1.0.0"
EOF
}

resource "harness_platform_service" "serviceDslim" {
  identifier = "serviceDslim"
  name       = "serviceDslim"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.development.id
  yaml       = <<EOF
service:
  name: serviceDslim
  identifier: serviceDslim
  tags: {}
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: template
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.Github
                  gitFetchType: Branch
                  paths:
                    - deployment.yaml
                  repoName: rssnyder/template
                  branch: main
              valuesPaths:
                - values.yaml
              skipResourceVersioning: false
      artifacts:
        primary:
          primaryArtifactRef: nginx
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: library/nginx
                tag: <+serviceVariables.version>
              identifier: nginx
              type: DockerRegistry
      variables:
        - name: port
          type: String
          description: ""
          value: "80"
          default: "80"
        - name: replicas
          type: String
          description: ""
          value: "1"
          default: "1"
        - name: version
          type: String
          description: ""
          value: "<+pipeline.variables.serviceA>"
          default: "1.0.0"
EOF
}
