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
variable "cloudflare_email" {
  type = string
  sensitive = true
}
variable "cloudflare_api_key" {
  type = string
  sensitive = true
}