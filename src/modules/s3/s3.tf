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

#web file objects
resource "aws_s3_object" "html_files" {
  for_each = fileset("${path.module}/${var.files}", "**/*.*")

  bucket       = aws_s3_bucket.bid_bucket.id
  key          = each.value
  source       = "${path.module}/${var.files}/${each.value}"
  etag         = filebase64("${path.module}/${var.files}/${each.value}")
  content_type = each.value
  #acl          = var.acl_type
}

resource "aws_s3_bucket_website_configuration" "static-website" {
  bucket = aws_s3_bucket.bid_bucket.id

  index_document {
    suffix = var.file
  }

  # error_document {
  #   key = var.file
  # }
}

resource "aws_s3_bucket_versioning" "my-static-website" {
  bucket = aws_s3_bucket.bid_bucket.id
  versioning_configuration {
    status = var.version_status
  }
}

