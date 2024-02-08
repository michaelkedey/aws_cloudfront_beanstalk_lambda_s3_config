# Upload an object
resource "aws_s3_object" "file" {
  bucket = var.s3_bucket_id
  key    = var.key
  source = var.file_path
  etag   = true #filemd5("${var.file_path}")

}
