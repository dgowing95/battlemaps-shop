variable "region" {
  type = string
}
variable "access_key" {
  type      = string
  sensitive = true
}
variable "secret_key" {
  type      = string
  sensitive = true
}
variable "nat_ami" {
  type = string
}
variable "nat_instance" {
  type    = string
  default = "t3.nano"
}
variable "public_ssh_key" {
  type      = string
  sensitive = true
}
variable "rds_root_password" {
  type      = string
  sensitive = true
}
variable "battlemaps_db_user" {
  type      = string
  sensitive = true
}
variable "battlemaps_db_pass" {
  type      = string
  sensitive = true
}
variable "battlemaps_db" {
  type      = string
  sensitive = true
}
variable "site_url" {
  type = string
}
variable "cloudflare_api_token" {
  type = string
  sensitive = true
}
variable "wp_auth_key" {
  type = string
  sensitive = true
}
variable "wp_secure_auth_key" {
  type = string
  sensitive = true
}
variable "wp_logged_in_key" {
  type = string
  sensitive = true
}
variable "wp_nonce_key" {
  type = string
  sensitive = true
}
variable "wp_auth_salt" {
  type = string
  sensitive = true
}
variable "wp_secure_auth_salt" {
  type = string
  sensitive = true
}
variable "wp_logged_in_salt" {
  type = string
  sensitive = true
}
variable "wp_nonce_salt" {
  type = string
  sensitive = true
}