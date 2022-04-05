resource "aws_ssm_parameter" "db_master_pass" {
    name = "/rds/orion_root_pass"
    type = "SecureString"
    value = var.rds_root_password
}
resource "aws_ssm_parameter" "db_host" {
    name = "/battlemaps/db_host"
    type = "String"
    value = aws_db_instance.main.address
}
resource "aws_ssm_parameter" "db_user" {
    name = "/battlemaps/db_user"
    type = "String"
    value = var.battlemaps_db_user
}
resource "aws_ssm_parameter" "db_pass" {
    name = "/battlemaps/db_pass"
    type = "SecureString"
    value = var.battlemaps_db_pass
}
resource "aws_ssm_parameter" "db" {
    name = "/battlemaps/db"
    type = "SecureString"
    value = var.battlemaps_db
}