output "firehose_stream_name" {
  description = "The name of the Firehose stream"
  value       = aws_kinesis_firehose_delivery_stream.this.name
}

output "firehose_stream_arn" {
  description = "The ARN of the Firehose stream"
  value       = aws_kinesis_firehose_delivery_stream.this.arn
}
