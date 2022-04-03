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
  type = string
  default = "t3.nano"
}
variable "public_ssh_key" {
  type = string
  sensitive = true
}