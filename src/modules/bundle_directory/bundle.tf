data "archive_file" "zipped_function" {
  type = var.archive_type
  #output_file_mode            = 0644
  source_dir                  = "${path.module}/${var.src_path}"
  output_path                 = "${path.module}/${var.output_path}.${var.archive_type}"
  exclude_symlink_directories = false
}