# Archive a single file.
data "archive_file" "app_or_function" {
  type                        = var.archive_type
  output_file_mode            = var.output_file_mode
  source_file                 = "${path.module}/${var.src_file}" #var.src_file
  output_path                 = "${path.module}/${var.output_path}.${var.archive_type}"
  exclude_symlink_directories = false

}
