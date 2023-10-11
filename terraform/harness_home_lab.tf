resource "harness_platform_project" "home_lab" {
  identifier = "home_lab"
  name       = "home_lab"
  org_id     = data.harness_platform_organization.default.id
}

resource "harness_platform_environment" "development" {
  identifier = "development"
  name       = "development"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.home_lab.id
  type       = "PreProduction"
  yaml       = <<EOF
environment:
  name: development
  identifier: development
  description: ""
  tags: {}
  type: PreProduction
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.home_lab.id}
  variables: []
EOF
}

resource "harness_platform_service" "harness_ccm_k8s_auto" {
  identifier = "harness_ccm_k8s_auto"
  name       = "harness ccm k8s auto"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.home_lab.id
  yaml       = <<EOF
service:
  name: harness ccm k8s auto
  identifier: harness_ccm_k8s_auto
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.home_lab.id}
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: main
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.${harness_platform_connector_github.Github.id}
                  gitFetchType: Branch
                  paths:
                    - deployment.yaml
                  repoName: harness-community/harness-ccm-k8s-auto
                  branch: main
              valuesPaths:
                - values.yaml
              skipResourceVersioning: false
              enableDeclarativeRollback: false
      artifacts:
        primary:
          primaryArtifactRef: <+input>
          sources:
            - spec:
                connectorRef: account.${harness_platform_connector_docker.dockerhub.id}
                imagePath: harnesscommunity/harness-ccm-k8s-auto
                tag: <+input>
                digest: ""
              identifier: main
              type: DockerRegistry
  gitOpsEnabled: false
EOF
}

resource "harness_platform_service" "ff_relay_proxy" {
  identifier = "ff_relay_proxy"
  name       = "ff relay proxy"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.home_lab.id
  yaml       = <<EOF
service:
  name: ff relay proxy
  identifier: ff_relay_proxy
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.home_lab.id}
  serviceDefinition:
    spec:
      manifests:
        - manifest:
            identifier: main
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.global
                  gitFetchType: Branch
                  paths:
                    - kubernetes/feature-flag-relay-proxy.yaml
                  repoName: harness-community/feature-flag-relay-proxy
                  branch: main
              skipResourceVersioning: false
              enableDeclarativeRollback: false
        - manifest:
            identifier: values
            type: Values
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.rssnyder
                  gitFetchType: Branch
                  paths:
                    - infra/k8s/ff-relay-proxy-values.yaml
                  repoName: isengard
                  branch: master
      artifacts:
        primary:
          primaryArtifactRef: <+input>
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: harness/ff-proxy
                tag: <+input>
                digest: ""
              identifier: main
              type: DockerRegistry
      variables:
        - name: port
          type: String
          description: ""
          required: true
          value: "7000"
        - name: replicas
          type: String
          description: ""
          required: true
          value: "2"
        - name: serviceType
          type: String
          description: ""
          required: false
          value: LoadBalancer
    type: Kubernetes

EOF
}

resource "harness_platform_service" "gitness" {
  identifier = "gitness"
  name       = "gitness"
  org_id     = data.harness_platform_organization.default.id
  project_id = harness_platform_project.home_lab.id
  yaml       = <<EOF
service:
  name: gitness
  identifier: gitness
  orgIdentifier: ${data.harness_platform_organization.default.id}
  projectIdentifier: ${harness_platform_project.home_lab.id}
  serviceDefinition:
    spec:
      manifests:
        - manifest:
            identifier: main
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.rssnyder
                  gitFetchType: Branch
                  paths:
                    - infra/k8s/gitness.yaml
                  repoName: isengard
                  branch: master
              skipResourceVersioning: false
              enableDeclarativeRollback: false
              valuesPaths:
                - infra/k8s/gitness-values.yaml
      artifacts:
        primary:
          primaryArtifactRef: <+input>
          sources:
            - spec:
                connectorRef: account.dockerhub
                imagePath: harness/gitness
                tag: <+input>
                digest: ""
              identifier: main
              type: DockerRegistry
    type: Kubernetes
EOF
}
