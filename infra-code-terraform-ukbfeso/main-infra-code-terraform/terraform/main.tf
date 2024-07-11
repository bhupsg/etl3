terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  # Your provider configuration such as region.
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod, sqa)"
  type        = string
}
