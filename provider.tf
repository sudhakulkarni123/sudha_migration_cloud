provider "aws" {
  region = var.region
}
terraform {
  required_version = ">= 1.1.0"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.66.1 "
    }
  }
}