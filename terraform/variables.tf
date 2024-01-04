variable "vscode_port" {
  type    = string
  default = "8080"
}

variable "vscode_password" {
  type = string
}

variable "harness_platform_api_key" {
  type      = string
  sensitive = true
}

variable "delegate_token" {
  sensitive = true
  default   = ""
}