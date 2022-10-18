#Provider versions
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws     = "3.42.0"
  }
}

#Provider config
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}
