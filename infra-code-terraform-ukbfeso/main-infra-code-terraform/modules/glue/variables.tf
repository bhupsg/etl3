# infra-code-terraform-ukbfeso\main-infra-code-terraform\modules\glue\variables.tf

variable "environment" {
  description = "The environment for the Glue databases (e.g., dev, sqa, prod)"
  type        = string
}

variable "database_names" {
  description = "List of Glue database names to create"
  type        = list(string)
}
