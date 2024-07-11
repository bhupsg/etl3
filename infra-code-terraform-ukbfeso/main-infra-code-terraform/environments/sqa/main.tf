provider "aws" {
  region = var.aws_region
}

module "kinesis_streams" {
  source         = "../../modules/kinesis_streams"
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  environment    = var.environment
  stream_names   = var.stream_names
}

module "s3_bucket" {
  source             = "../../modules/s3_bucket"
  environment        = var.environment
  bucket_name_prefix = "s3"
  bucket_name        = "s3-${var.environment}-datalake-ukbfeso"
  subfolders         = ["curated", "enriched", "landing", "raw"]
  raw_subfolders     = ["inspectorrestarts", "touchpointrestarts", "touchpointstatus"]
}

module "s3_bucket_artifacts" {
  source             = "../../modules/s3_bucket"
  environment        = var.environment
  bucket_name_prefix = "s3"
  bucket_name        = "s3-${var.environment}-artifacts-ukbfeso"
  subfolders         = ["glue_jobs", "lambda_layers"]
}

module "glue_databases" {
  source         = "../../modules/glue"
  environment    = var.environment
  database_names = [
    "glue-table-${var.environment}-curated-ukbfeso",
    "glue-table-${var.environment}-enriched-ukbfeso"
  ]
}

module "parameter_store" {
  source                     = "../../modules/parameter_store"
  environment                = var.environment
  datalake_parameter_name    = "/ukbfeso/datalake-storage"
  datalake_parameter_value   = jsonencode({
    storage = {
      s3 = {
        bucket   = "s3-${var.environment}-datalake-ukbfeso"
        prefixes = {
          layer0 = "raw"
          layer1 = "curated"
          layer2 = "enriched"
        }
      }
    }
  })
  glue_databases_parameter_name  = "/ukbfeso/glue-databases"
  glue_databases_parameter_value = jsonencode({
    glue = {
      crawlers = {}
      databases = {
        curated  = "glue-table-${var.environment}-curated-ukbfeso"
        enriched = "glue-table-${var.environment}-enriched-ukbfeso"
      }
      dimensions = {}
    }
  })
}

module "lambda_function_inspectorrestarts" {
  source        = "../../modules/lambda_function"
  aws_region    = var.aws_region
  environment   = var.environment
  function_name = "lambda-${var.environment}-firehose-inspectorrestarts-ukbfeso"
  filename      = "C:/Users/OtherUser01/Documents/JobPlaces/1_VisionBox/Projects/infra-code-terraform-ukbfeso/main-infra-code-terraform/scripts/ukbfeso_lambda.zip"
  role_name     = "iam-role-${var.environment}-lambda-firehose-inspectorrestarts-ukbfeso"
}

module "lambda_function_touchpointrestarts" {
  source        = "../../modules/lambda_function"
  aws_region    = var.aws_region
  environment   = var.environment
  function_name = "lambda-${var.environment}-firehose-touchpointrestarts-ukbfeso"
  filename      = "C:/Users/OtherUser01/Documents/JobPlaces/1_VisionBox/Projects/infra-code-terraform-ukbfeso/main-infra-code-terraform/scripts/ukbfeso_lambda.zip"
  role_name     = "iam-role-${var.environment}-lambda-firehose-touchpointrestarts-ukbfeso"
}

module "lambda_function_touchpointstatus" {
  source        = "../../modules/lambda_function"
  aws_region    = var.aws_region
  environment   = var.environment
  function_name = "lambda-${var.environment}-firehose-touchpointstatus-ukbfeso"
  filename      = "C:/Users/OtherUser01/Documents/JobPlaces/1_VisionBox/Projects/infra-code-terraform-ukbfeso/main-infra-code-terraform/scripts/ukbfeso_lambda.zip"
  role_name     = "iam-role-${var.environment}-lambda-firehose-touchpointstatus-ukbfeso"
}

/*
module "iam_policy" {
  source      = "../../modules/iam_policy"
  name        = "policy-kinesis-fh-${var.environment}-inspectorrestarts-ukbfeso"
  description = "Policy for Kinesis Firehose Inspector Restarts"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = ""
        Effect   = "Allow"
        Action   = ["glue:GetTable", "glue:GetTableVersion", "glue:GetTableVersions"]
        Resource = [
          "arn:aws:glue:${var.aws_region}:${var.aws_account_id}:catalog",
          "arn:aws:glue:${var.aws_region}:${var.aws_account_id}:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
          "arn:aws:glue:${var.aws_region}:${var.aws_account_id}:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
        ]
      },
      {
        Sid      = ""
        Effect   = "Allow"
        Action   = ["kafka:GetBootstrapBrokers", "kafka:DescribeCluster", "kafka:DescribeClusterV2", "kafka-cluster:Connect"]
        Resource = "arn:aws:kafka:${var.aws_region}:${var.aws_account_id}:cluster/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
      },
      {
        Sid      = ""
        Effect   = "Allow"
        Action   = ["kafka-cluster:DescribeTopic", "kafka-cluster:DescribeTopicDynamicConfiguration", "kafka-cluster:ReadData"]
        Resource = "arn:aws:kafka:${var.aws_region}:${var.aws_account_id}:topic/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
      },
      {
        Sid      = ""
        Effect   = "Allow"
        Action   = ["kafka-cluster:DescribeGroup"]
        Resource = "arn:aws:kafka:${var.aws_region}:${var.aws_account_id}:group/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*"
      },
      {
        Sid      = ""
        Effect   = "Allow"
        Action   = ["s3:AbortMultipartUpload", "s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:PutObject"]
        Resource = [
          "arn:aws:s3:::s3-${var.environment}-datalake-ukbfeso",
          "arn:aws:s3:::s3-${var.environment}-datalake-ukbfeso/*"
        ]
      },
      {
        Sid      = ""
        Effect   = "Allow"
        Action   = ["lambda:InvokeFunction", "lambda:GetFunctionConfiguration"]
        Resource = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:lambda-${var.environment}-firehose-inspectorrestarts-ukbfeso:$LATEST"
      },
      {
        Effect   = "Allow"
        Action   = ["kms:GenerateDataKey", "kms:Decrypt"]
        Resource = ["arn:aws:kms:${var.aws_region}:${var.aws_account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"]
        Condition = {
          StringEquals = {
            "kms:ViaService" = "s3.${var.aws_region}.amazonaws.com"
          }
          StringLike = {
            "kms:EncryptionContext:aws:s3:arn" = [
              "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
              "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
            ]
          }
        }
      },
      {
        Sid      = ""
        Effect   = "Allow"
        Action   = ["logs:PutLogEvents"]
        Resource = [
          "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/kinesisfirehose/kinesis-fh-${var.environment}-inspectorrestarts-ukbfeso:log-stream:*",
          "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*"
        ]
      },
      {
        Sid      = ""
        Effect   = "Allow"
        Action   = ["kinesis:DescribeStream", "kinesis:GetShardIterator", "kinesis:GetRecords", "kinesis:ListShards"]
        Resource = "arn:aws:kinesis:${var.aws_region}:${var.aws_account_id}:stream/kinesis-ds-${var.environment}-inspectorrestarts-ukbfeso"
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = ["arn:aws:kms:${var.aws_region}:${var.aws_account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"]
        Condition = {
          StringEquals = {
            "kms:ViaService" = "kinesis.${var.aws_region}.amazonaws.com"
          }
          StringLike = {
            "kms:EncryptionContext:aws:kinesis:arn" = "arn:aws:kinesis:${var.aws_region}:${var.aws_account_id}:stream/kinesis-ds-${var.environment}-inspectorrestarts-ukbfeso"
          }
        }
      }
    ]
  })
}

module "iam_role" {
  source              = "../../modules/iam_role"
  name                = "iam-role-${var.environment}-firehose-inspectorrestarts-ukbfeso"
  assume_role_policy  = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}


module "iam_policy_attachment" {
  source     = "../../modules/iam_policy_attachment"
  role_name  = module.iam_role.role_name
  policy_arn = module.iam_policy.arn
}


module "kinesis_firehose" {
  source                  = "../../modules/kinesis_firehose"
  name                    = "kinesis-fh-${var.environment}-inspectorrestarts-ukbfeso"
  stream_name             = "kinesis-fh-${var.environment}-inspectorrestarts-ukbfeso"
  source_stream_arn       = "arn:aws:kinesis:${var.aws_region}:${var.aws_account_id}:stream/kinesis-ds-${var.environment}-inspectorrestarts-ukbfeso"
  transform_function_arn  = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:lambda-${var.environment}-firehose-inspectorrestarts-ukbfeso"
  s3_bucket_arn           = "arn:aws:s3:::s3-${var.environment}-datalake-ukbfeso"
  s3_bucket_prefix        = "raw/inspectorrestarts/"
  s3_prefix               = "raw/inspectorrestarts/"
  iam_role_arn            = "arn:aws:iam::${var.aws_account_id}:role/iam-role-${var.environment}-firehose-inspectorrestarts-ukbfeso"
  lambda_arn              = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:lambda-${var.environment}-firehose-inspectorrestarts-ukbfeso"
}
*/
/*
module "kinesis_firehose" {
  source                  = "../../modules/kinesis_firehose"
  name                    = "kinesis-fh-${var.environment}-inspectorrestarts_2-ukbfeso"
  stream_name             = "kinesis-fh-${var.environment}-inspectorrestarts_2-ukbfeso"
  source_stream_arn       = "arn:aws:kinesis:${var.aws_region}:${var.aws_account_id}:stream/kinesis-ds-${var.environment}-inspectorrestarts-ukbfeso"
  transform_function_arn  = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:lambda-${var.environment}-firehose-inspectorrestarts-ukbfeso"
  s3_bucket_arn           = "arn:aws:s3:::s3-${var.environment}-datalake-ukbfeso"
  s3_bucket_prefix        = "raw/inspectorrestarts/"
  s3_prefix               = "raw/inspectorrestarts/"
  iam_role_arn            = "arn:aws:iam::287529731045:role/iam-role-sqa-firehose-inspectorrestarts-ukbfeso"
  lambda_arn              = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:lambda-${var.environment}-firehose-inspectorrestarts-ukbfeso"
}
*/