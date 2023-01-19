# resource "harness_platform_pipeline" "build_react-image-compressor" {
#   identifier = "build_react_image_compressor"
#   org_id     = data.harness_platform_organization.default.id
#   project_id = harness_platform_project.development.id
#   name       = "build_react_image_compressor"

#   yaml = <<EOF
# pipeline:
#   name: build_react_image_compressor
#   identifier: build_react_image_compressor
#   projectIdentifier: ${harness_platform_project.development.id}
#   orgIdentifier: ${data.harness_platform_organization.default.id}
#   tags: {}
#   properties:
#     ci:
#       codebase:
#         connectorRef: account.rssnyder
#         repoName: react-image-compressor
#         build: <+input>
#   stages:
#     - stage:
#         name: approve
#         identifier: approve
#         description: ""
#         type: Approval
#         tags: {}
#         spec:
#           execution:
#             steps:
#               - step:
#                   name: approve
#                   identifier: approve
#                   type: HarnessApproval
#                   timeout: 1d
#                   spec:
#                     approvalMessage: |-
#                       Please review the following information
#                       and approve the pipeline progression
#                     includePipelineExecutionHistory: true
#                     approvers:
#                       minimumCount: 1
#                       disallowPipelineExecutor: false
#                       userGroups:
#                         - approvers
#                     approverInputs: []
#     - stage:
#         name: build
#         identifier: build
#         template:
#           templateRef: account.build_imge
#           versionLabel: "1"
#           templateInputs:
#             type: CI
#             spec:
#               execution:
#                 steps:
#                   - step:
#                       identifier: build_and_push
#                       type: BuildAndPushDockerRegistry
#                       spec:
#                         dockerfile: <+input>
# EOF
# }