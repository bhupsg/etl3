output "kinesis_stream_names" {
  value = aws_kinesis_stream.kinesis_stream[*].name
}
