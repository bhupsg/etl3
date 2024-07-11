variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "filename" {
  description = "Path to the Lambda deployment package"
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role for the Lambda function"
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod, sqa)"
  type        = string
}
