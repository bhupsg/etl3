# main-infra-code-terraform\modules\glue\main.tf

resource "aws_glue_catalog_database" "this" {
  count = length(var.database_names)
  
  name = var.database_names[count.index]

  parameters = {
    CreatedBy = "Terraform"
  }
}
