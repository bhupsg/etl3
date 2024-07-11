# ..modules/lambda_function

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name

  role          = data.aws_iam_role.lambda_role.arn
  handler       = "ukbfeso_lambda.lambda_handler"
  runtime       = "python3.8"

  filename      = var.filename

  timeout      = 60
  memory_size  = 128
}

data "aws_iam_role" "lambda_role" {
  name = var.role_name
}
