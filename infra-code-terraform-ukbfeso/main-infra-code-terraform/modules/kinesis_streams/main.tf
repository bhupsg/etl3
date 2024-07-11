provider "aws" {
  region = var.aws_region
}

resource "aws_kinesis_stream" "kinesis_stream" {
  count             = length(var.stream_names)
  name              = "kinesis-ds-${var.environment}-${var.stream_names[count.index]}-ukbfeso"
  shard_count       = 1
  retention_period  = 24
}
