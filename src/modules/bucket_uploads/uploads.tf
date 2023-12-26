#upload files
# resource "aws_s3_object" "files" {
#   for_each = fileset("${path.module}/${var.file_path}", "**/*.*")

#   bucket = var.s3_bucket_id
#   key    = each.value
#   source = "${path.module}/${var.file_path}"
#   #etag         = filebase64("${path.module}/${var.file_path}/${each.value}")
#   content_type = each.value

# }


# Upload an object
resource "aws_s3_bucket_object" "file" {
  bucket = var.s3_bucket_id
  key    = var.key
  #acl    = "private"  # or can be "public-read"
  source = var.file_path
  etag   = true #filemd5("${var.file_path}")


}
