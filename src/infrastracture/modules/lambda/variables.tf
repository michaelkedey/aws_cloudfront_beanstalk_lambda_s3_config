variable "lambda_iam_role_name" {
  default = "iam_role_for_lambda"

}

variable "lambda_iam_role_policy_name" {
  default = "iam_role_policy_for_lambda"
}

variable "lambda_policy_arn" {
  default = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

variable "lambda_file" {}

variable "lambda_memory_size" {
  default = 256
}

variable "lambda_timeout" {
  default = 10
}

variable "src_code_hash" {}

variable "security_group_ids" {
  type = set(string)
}

variable "vpc_subnet_ids" {}

variable "lambda_tags" {
  default = {
    Project     = "bid",
    Owners      = "bid",
    Environment = "dev"
  }
}

variable "tracing_mode" {
  default = "Active"
}

#variable "event_source_arn" {}

#variable "lambda_layers" {}

variable "lambda_function_name" {
  type    = string
  default = "auto_deploy_lambda"

}

# variable "s3_bucket_arn" {
#   type = string
# }

variable "func_runtime" {
  default = "python3.8" #"nodejs18.x"
  type    = string
}

# variable "trigger_bucket_arn" {

# }

variable "lambda_func_handler" {
  default = "auto_deploy_function.lambda_handler"
  type    = string
}

variable "eb_env_name" {}

variable "s3_bucket_name" {}

variable "suffix" {
  type = string
}

variable "prefix" {
  type = string
}

variable "eb_app_name" {}

variable "s3_bucket_bucket" {
  
}