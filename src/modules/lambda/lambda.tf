#lambda assume role
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = var.effect

#     principals {
#       type        = var.assume_role_principal_type
#       identifiers = ["${var.assume_role_principal_id}"]
#     }

#     actions = ["${var.assume_role_actions}"]
#   }
# }

# resource "aws_iam_role" "lambda_iam" {
#   name               = var.lambda_iam_name
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# data "aws_iam_policy_document" "lambda_policy" {
#   statement {
#     effect = var.effect

#     actions = var.actions

#     resources = ["${var.bucket_arn}", "${var.bucket_arn}/*"]

#   }
# }

# resource "aws_iam_role_policy" "lambda_policy" {
#   name   = var.lambda_policy_name
#   role   = aws_iam_role.lambda_iam.id
#   policy = data.aws_iam_policy_document.lambda_policy.json
# }


resource "aws_iam_role" "lambda_execution_role" {
  name = var.lambda_iam_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy" {
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "LambdaExecutionPolicy"
  description = "Policy for Lambda execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["DeleteNetworkInterface", "ec2:DescribeNetworkInterfaces", "ec2:CreateNetworkInterface", "s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  policy_arn = var.vpc_access_role
  role       = aws_iam_role.lambda_execution_role.name
}


# data "archive_file" "lambda" {
#   type        = var.archive_type
#   source_file = ("${path.module}/${var.src_file}")
#   output_path = ("${path.module}/${var.src_file}.zip")
# }

resource "aws_lambda_function" "bid_lambda_fn" {
  filename      = var.src_file_zip
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = var.lambda_func_handler

  source_code_hash = var.src_code_hash

  runtime     = var.func_runtime
  memory_size = var.lambda_memory_size
  timeout     = var.lambda_timeout

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }

  # Enable versioning for Lambda function
  publish = true

  # CloudWatch Logs configuration
  #   tracing_config {
  #     mode = var.tracing_mode
  #   }

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.vpc_subnet_ids
  }

  #   layers = var.lambda_layers

  tags = var.lambda_tags

  tracing_config {
    mode = var.tracing_mode
  }

  #   dead_letter_config {
  #     target_arn = var.dead_letter_queue_arn
  #   }

  #event_source_arn = var.event_source_arn 

}

resource "aws_lambda_event_source_mapping" "bid_source" {
  event_source_arn = var.event_source_arn
  function_name    = aws_lambda_function.bid_lambda_fn.function_name
  enabled          = true
}







