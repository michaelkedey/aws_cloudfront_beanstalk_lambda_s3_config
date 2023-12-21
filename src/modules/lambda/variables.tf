variable "effect" {
  default = "Allow"
  type    = string

}

variable "assume_role_principal_type" {
  default = "Service"
  type    = string

}

variable "assume_role_principal_id" {
  default = "lambda.amazonaws.com"

}

variable "assume_role_actions" {
  default = "sts:AssumeRole"
}

variable "lambda_iam_name" {
  default = "iam_for_lambda"

}

variable "actions" {
  default = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject",
    "s3:ListBucket"

  ]
  type = list(string)
}


variable "publish" {
  default = true

}

variable "archive_type" {
  default = "zip"

}

variable "output_path" {
  default = "lambda_function_payload.zip"
}

variable "lambda_func_name" {
  default = "lambda_function_payload.zip"

}

variable "lambda_function_name" {
  default = "lambda_function_name"

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

#variable "lambda_layers" {}

variable "provisioned_concurrent_executions" {
  default = 5
}

variable "lambda_tags" {
  default = {
    Project     = "bid",
    Owners      = "bid",
    Environment = "Production"
  }
}

variable "lambda_policy_name" {
  default = "lambda_policy"

}

#placeholders
variable "sceurity_group_ids" {
  type = set(string)
}

variable "bucket_arn" {}
variable "event_source_arn" {}
variable "bucket_name" {}

variable "file_path" {
  default = "./functions/name_form.js"
}

variable "lambda_func_handler" {
  default = "handler"
}


variable "vpc_subnet_ids" {
  type = list(string)
}


variable "tracing_mode" {
  default = "Active"
}