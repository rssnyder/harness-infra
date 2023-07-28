resource "random_password" "password" {
  length           = 18
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}