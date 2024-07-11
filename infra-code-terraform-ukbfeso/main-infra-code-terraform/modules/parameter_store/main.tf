
/*
# infra-code-terraform-ukbfeso\main-infra-code-terraform\modules\parameter_store\main.tf

resource "aws_ssm_parameter" "datalake_storage" {
  name  = var.parameter_name
  type  = "String"
  value = var.parameter_value

  tags = {
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "glue_databases" {
  name  = var.glue_databases_parameter_name
  type  = "String"
  value = var.glue_databases_parameter_value

  tags = {
    Environment = var.environment
  }
}
*/

# ..\infra-code-terraform-ukbfeso\main-infra-code-terraform\modules\parameter_store\main.tf

resource "aws_ssm_parameter" "datalake_storage" {
  name  = var.datalake_parameter_name
  type  = "String"
  value = var.datalake_parameter_value

  tags = {
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "glue_databases" {
  name  = var.glue_databases_parameter_name
  type  = "String"
  value = var.glue_databases_parameter_value

  tags = {
    Environment = var.environment
  }
}
