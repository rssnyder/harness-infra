resource "random_password" "password" {
  length           = 19
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}