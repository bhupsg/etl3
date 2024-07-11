variable "name" {
  description = "The name of the Kinesis Firehose delivery stream"
  type        = string
}

variable "source_stream_arn" {
  description = "The ARN of the source Kinesis stream"
  type        = string
}

variable "lambda_arn" {
  description = "The ARN of the Lambda function for transformation"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the destination S3 bucket"
  type        = string
}

variable "s3_bucket_prefix" {
  description = "The prefix for the S3 bucket"
  type        = string
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role"
  type        = string
}

resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.name
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.source_stream_arn
    role_arn           = var.iam_role_arn
  }

  extended_s3_configuration {
    role_arn         = var.iam_role_arn
    bucket_arn       = var.s3_bucket_arn
    prefix           = var.s3_bucket_prefix

    processing_configuration {
      enabled = true

      processors {
        type = "Lambda"
        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = var.lambda_arn
        }
      }
    }
  }
}
