terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "dg"

      workspaces {
        name = "battlemaps-shop"
      }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}