terraform {
  source = "../terraform"
}

inputs = {
  aws_region = "eu-west-2"
  aws_account_id = "287529731045" # Use your actual SQA AWS account ID
  environment   = "sqa"
  stream_names = [
    "inspectorrestarts",
    "touchpointrestarts",
    "touchpointstatus",
  ]
}