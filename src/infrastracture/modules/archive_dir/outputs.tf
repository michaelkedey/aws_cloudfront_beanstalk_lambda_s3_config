output "app_or_function_output_path" {
  value = data.archive_file.dir.output_path
}

output "src_code_hash" {
  value = data.archive_file.dir.output_base64sha256
}