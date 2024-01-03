variable "bucket_name" {
  type = string

}

variable "lambda_key" {
  default = "name_form.js.zip"
  type    = string
}


variable "app_key" {
  default = "LambdaWebApp2.zip"
  type    = string
}

variable "func_handler" {
  default = "index.handler"
  type    = string
}

variable "app_name" {
  type    = string

}

variable "version_name" {
  type = string

}

variable "max_instance" {
  type    = number

}

variable "min_instance" {
  type    = number

}

variable "root_vol_type" {
  type    = string

}

variable "root_vol_size" {
  type    = number

}

variable "beanstalk_env_name" {
  type    = string

}

variable "instance_type" {
  type    = string

}

variable "lambda_archive_source" {
  default = "../../functions/lambda/name_form.js"
  type    = string

}

variable "lambda_archive_output" {
  default = "../../s3_uploads/name_form.js"
  type    = string

}

variable "app_archive_source" {
  default = "../../functions/dotnet/LambdaWebApp"
  type    = string

}

variable "app_archive_output" {
  default = "../../s3_uploads/LambdaWebApp"
  type    = string

}

variable "lambda_file_upload" {
  default = "./s3_uploads/name_form.js.zip"
  type    = string

}

variable "app_file_upload" {
  default = "./s3_uploads/LambdaWebApp2.zip"
  type    = string

}

variable "lambda_file" {
  default = "../../s3_uploads/name_form.js.zip"
  type = string
}

# variable "s3_backend" {
#   type = string

# }

# variable "backend_key" {
#   type = string

# }

# variable "backend_region" {
#   type = string

# }

# variable "deploy_region" {
#  type = string
# }

  