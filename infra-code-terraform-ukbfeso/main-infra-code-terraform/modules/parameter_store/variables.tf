# ..\infra-code-terraform-ukbfeso\main-infra-code-terraform\modules\parameter_store\variables.tf

variable "environment" {
  description = "The environment for the Parameter Store entry (e.g., dev, sqa, prod)"
  type        = string
}

variable "datalake_parameter_name" {
  description = "The name of the datalake Parameter Store entry"
  type        = string
}

variable "datalake_parameter_value" {
  description = "The value of the datalake Parameter Store entry"
  type        = string
}

variable "glue_databases_parameter_name" {
  description = "The name of the glue databases Parameter Store entry"
  type        = string
}

variable "glue_databases_parameter_value" {
  description = "The value of the glue databases Parameter Store entry"
  type        = string
}
