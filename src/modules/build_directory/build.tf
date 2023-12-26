# # Archive a single file.
# data "archive_file" "app_or_function" {
#   type                        = var.archive_type
#   output_file_mode            = var.output_file_mode
#   source_file                 = "${path.module}/${var.src_file}" #var.src_file
#   output_path                 = "${path.module}/${var.output_path}.${var.archive_type}"
#   exclude_symlink_directories = false

# }


# resource "null_resource" "archive_directory" {
#   provisioner "local-exec" {
#     command = "zip -r ${var.src_file} ${var.src_filezip}"
#   }
# }

# data "archive_file" "app_or_function" {
#   # ... other attributes
#   source_file = var.src_file  # Reference the temporary archive
#   type                        = var.archive_type
#   output_path                 = "${path.module}/${var.output_path}"
# }
