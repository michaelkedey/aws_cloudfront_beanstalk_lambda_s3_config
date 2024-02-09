variable "bucket_name" {
  type = string

}

variable "lambda_key" {
  default = "auto_deploy_function.py.zip"
  type    = string
}


variable "app_key" {
  default = "LambdaWebApp2.zip"
  type    = string
}

variable "app_name" {
  type = string

}

variable "max_instance" {
  type = number

}

variable "min_instance" {
  type = number

}

variable "root_vol_type" {
  type = string

}

variable "root_vol_size" {
  type = number

}

variable "beanstalk_env_name" {
  type    = string
  default = "deployment_env"
}

variable "instance_type" {
  type = string

}

variable "lambda_archive_source" {
  default = "../../functions/lambda/auto_deploy_function.py"
  type    = string

}

variable "lambda_archive_output" {
  default = "../../s3_uploads/auto_deploy_function.py"
  type    = string

}

variable "lambda_file_upload" {
  default = "./s3_uploads/auto_deploy_function.py.zip"
  type    = string

}

variable "app_file_upload" {
  default = "./s3_uploads/LambdaWebbApp2.zip"
  type    = string

}
