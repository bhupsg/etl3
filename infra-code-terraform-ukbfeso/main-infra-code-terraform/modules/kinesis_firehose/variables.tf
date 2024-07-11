variable "stream_name" {
  description = "The name of the Firehose stream"
  type        = string
}

variable "transform_function_arn" {
  description = "The ARN of the Lambda function for transformation"
  type        = string
}

variable "s3_prefix" {
  description = "The prefix in the S3 bucket"
  type        = string
}



