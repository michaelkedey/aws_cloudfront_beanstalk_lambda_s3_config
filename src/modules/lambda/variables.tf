variable "lambda_iam_name" {
  default = "iam_for_lambda"

}

variable "vpc_access_role" {
  default = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

variable "lambda_file" {}

variable "lambda_func_handler" {}

variable "lambda_func_name" {
  default = "lambda_function_payload.zip"

}

variable "func_runtime" {
  default = "nodejs18.x"

}

variable "lambda_memory_size" {
  default = 256
}

variable "lambda_timeout" {
  default = 10
}

variable "src_code_hash" {}

variable "bucket_name" {}

variable "security_group_ids" {
  type = set(string)
}

variable "vpc_subnet_ids" {}

variable "lambda_tags" {
  default = {
    Project     = "bid",
    Owners      = "bid",
    Environment = "Production"
  }
}

variable "tracing_mode" {
  default = "Active"
}

#variable "event_source_arn" {}

#variable "lambda_layers" {}

variable "lambda_function_name" {
  default = "lambda_function_name"

}
