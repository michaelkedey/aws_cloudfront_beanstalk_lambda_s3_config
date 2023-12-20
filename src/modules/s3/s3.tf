#bucket
resource "aws_s3_bucket" "bid_bucket" {
  bucket = var.name
  tags = merge(
    var.tags_all,
    {
      Name = var.name
    }
  )
}

#bucket acl
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.bid_bucket.id
  acl    = var.acl
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.bid_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#web file objects
resource "aws_s3_object" "html_files" {
  for_each = fileset(var.file_path, "**/*")

  bucket = aws_s3_bucket.bid_bucket.id
  key    = each.value
  source = "${var.file_path}/${each.value}"
  etag   = filebase64("${var.file_path}/${each.value}")
  content_type = lookup({
    ".html"  = "text/html",
    ".jpeg"  = "image/jpeg",
    ".jpg"   = "image/jpeg",
  }, fileext(each.value), "application/octet-stream") #default for unknown types

  depends_on = [
    aws_s3_bucket.bid_bucket
  ]
}

#configure static server
resource "aws_s3_bucket_website_configuration" "static-website" {
  bucket = aws_s3_bucket.bid.id

  index_document {
    suffix = var.suffix
  }

  # error_document {
  #   key = var.error
  # }
}

#enable bucket versioning
resource "aws_s3_bucket_versioning" "my-static-website" {
  bucket = aws_s3_bucket.bid.id
  versioning_configuration {
    status = var.version_status
  }
}










