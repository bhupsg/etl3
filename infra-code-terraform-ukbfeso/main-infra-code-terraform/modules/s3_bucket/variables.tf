# modules/s3_bucket/variables.tf

variable "environment" {
  description = "The environment for the S3 bucket (e.g., dev, sqa, prod)"
  type        = string
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
  default     = "s3"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "subfolders" {
  description = "List of subfolders to create in the S3 bucket"
  type        = list(string)
  default     = []
}

variable "raw_subfolders" {
  description = "List of subfolders to create under the raw folder in the S3 bucket"
  type        = list(string)
  default     = []
}
