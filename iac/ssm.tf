resource "aws_ssm_parameter" "db_master_pass" {
  name  = "/rds/orion_root_pass"
  type  = "SecureString"
  value = var.rds_root_password
}
resource "aws_ssm_parameter" "db_host" {
  name  = "/battlemaps/db_host"
  type  = "String"
  value = aws_db_instance.main.address
}
resource "aws_ssm_parameter" "db_user" {
  name  = "/battlemaps/db_user"
  type  = "String"
  value = var.battlemaps_db_user
}
resource "aws_ssm_parameter" "db_pass" {
  name  = "/battlemaps/db_pass"
  type  = "SecureString"
  value = var.battlemaps_db_pass
}
resource "aws_ssm_parameter" "db" {
  name  = "/battlemaps/db"
  type  = "SecureString"
  value = var.battlemaps_db
}
resource "aws_ssm_parameter" "wp_auth_key" {
  name = "/battlemaps/wp_auth_key"
  type = "SecureString"
  value = var.wp_auth_key
}
resource "aws_ssm_parameter" "wp_secure_auth_key" {
  name = "/battlemaps/wp_secure_auth_key"
  type = "SecureString"
  value = var.wp_secure_auth_key
}
resource "aws_ssm_parameter" "wp_logged_in_key" {
  name = "/battlemaps/wp_logged_in_key"
  type = "SecureString"
  value = var.wp_logged_in_key
}
resource "aws_ssm_parameter" "wp_nonce_key" {
  name = "/battlemaps/wp_nonce_key"
  type = "SecureString"
  value = var.wp_nonce_key
}
resource "aws_ssm_parameter" "wp_auth_salt" {
  name = "/battlemaps/wp_auth_salt"
  type = "SecureString"
  value = var.wp_auth_salt
}
resource "aws_ssm_parameter" "wp_secure_auth_salt" {
  name = "/battlemaps/wp_secure_auth_salt"
  type = "SecureString"
  value = var.wp_secure_auth_salt
}
resource "aws_ssm_parameter" "wp_logged_in_salt" {
  name = "/battlemaps/wp_logged_in_salt"
  type = "SecureString"
  value = var.wp_logged_in_salt
}
resource "aws_ssm_parameter" "wp_nonce_salt" {
  name = "/battlemaps/wp_nonce_salt"
  type = "SecureString"
  value = var.wp_nonce_salt
}