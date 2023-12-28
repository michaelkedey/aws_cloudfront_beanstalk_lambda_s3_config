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
        Effect = "Allow"
        Action = [
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "lambda:InvokeFunction",
          "logs:CreateLogGroup",
          "logs:CreateLogStream"

        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  policy_arn = var.vpc_access_role
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_lambda_function" "bid_lambda_fn" {
  filename      = "${path.module}/${var.lambda_file}"
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = var.lambda_func_handler

  source_code_hash = var.src_code_hash
  runtime          = var.func_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout

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

# resource "aws_lambda_event_source_mapping" "bid_source" {
#   event_source_arn = var.event_source_arn
#   function_name    = aws_lambda_function.bid_lambda_fn.function_name
#   enabled          = true
# }

resource "aws_api_gateway_rest_api" "lambda_api" {
  name        = "LambdaAPI"
  description = "API for Lambda function"
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = "lambda"
}

resource "aws_api_gateway_method" "lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.lambda_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.bid_lambda_fn.invoke_arn
}

resource "aws_api_gateway_deployment" "lambda_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  stage_name  = "prod"
}
