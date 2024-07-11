variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod, sqa)"
  type        = string
}

variable "stream_names" {
  description = "List of base names for the Kinesis Data Streams"
  type        = list(string)
}

