# modules/iam_role/variables.tf

variable "name" {
  description = "The name of the IAM role"
  type        = string
}

variable "assume_role_policy" {
  description = "The assume role policy document in JSON format"
  type        = string
}
