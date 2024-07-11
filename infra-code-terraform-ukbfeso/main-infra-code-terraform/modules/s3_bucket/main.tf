# modules/s3_bucket/main.tf

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_object" "subfolders" {
  count   = length(var.subfolders)
  bucket  = aws_s3_bucket.this.bucket
  key     = "${tolist(var.subfolders)[count.index]}/"
}

resource "aws_s3_object" "raw_subfolders" {
  count   = length(var.raw_subfolders)
  bucket  = aws_s3_bucket.this.bucket
  key     = "raw/${tolist(var.raw_subfolders)[count.index]}/"
}
