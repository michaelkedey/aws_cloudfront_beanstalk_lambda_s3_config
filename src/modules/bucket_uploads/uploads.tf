#upload files
resource "aws_s3_object" "files" {
  for_each = fileset("${path.module}/${var.file_path}", "**/*.*")

  bucket       = var.s3_bucket_id
  key          = each.value
  source       = "${path.module}/${var.file_path}/${each.value}"
  #etag         = filebase64("${path.module}/${var.file_path}/${each.value}")
  content_type = each.value

}
