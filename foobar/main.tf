resource "random_password" "password" {
  length           = 17
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}