#bucket
resource "aws_s3_bucket" "bid_bucket" {
  bucket = var.bucket_name
  tags = merge(
    var.tags_all,
    {
      Name = var.bucket_name
    }
  )
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.bid_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "my-static-website" {
  bucket = aws_s3_bucket.bid_bucket.id
  versioning_configuration {
    status = var.version_status
  }
}

