variable "archive_type" {
  default = "zip"
}

variable "output_file_mode" {
  default = "0666"
}

variable "src_file" {
  type = string
}

variable "output_path" {
  type = string
}
