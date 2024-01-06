resource "aws_iam_role" "lambda_execution_role" {
  name = var.lambda_iam_role_name

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy_attachment" {
  policy_arn = var.lambda_policy_arn
  role       = aws_iam_role.lambda_execution_role.name
}


resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "LambdaExecutionPolicy"
  description = "Policy for Lambda execution"
  policy      = file("${path.module}/lambda_execution_policy.json")
}


resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy_attachment-2" {
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}


# resource "aws_iam_policy" "lambda_execution_policy" {
#   name        = "LambdaExecutionPolicy"
#   description = "Policy for Lambda execution"
#   policy = file("${path.module}/lambda_iam_policy")

# }

# resource "aws_iam_role_policy_attachment" "lambda_access" {
#   policy_arn = aws_iam_policy.lambda_execution_policy.arn
#   role       = aws_iam_role.lambda_execution_role.name
# }

#lambda
resource "aws_lambda_function" "bid_lambda_fn" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = var.lambda_func_handler
  runtime       = var.func_runtime
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  # Specify the deployment code
  filename         = "${path.module}/${var.lambda_file}"
  source_code_hash = var.src_code_hash

  # Specify environment variables
  environment {
    variables = {
      EB_ENVIRONMENT_NAME = var.eb_env_name
      S3_BUCKET_NAME      = var.s3_bucket_name
      CODE_SUFFIX         = var.suffix
      CODE_PREFIX         = var.prefix
      EB_APPLICATION_NAME = var.eb_app_name
    }
  }

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.vpc_subnet_ids
  }

  tags = var.lambda_tags

  tracing_config {
    mode = var.tracing_mode
  }

}

# # S3 event trigger for Lambda function
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = var.s3_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.deploy_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.prefix
    filter_suffix       = var.suffix
  }
}

# resource "aws_lambda_event_source_mapping" "bid_source" {
#   event_source_arn = var.event_source_arn
#   function_name    = aws_lambda_function.bid_lambda_fn.function_name
#   enabled          = true
# }

# resource "aws_api_gateway_rest_api" "lambda_api" {
#   name        = "LambdaAPI"
#   description = "API for Lambda function"
# }

# resource "aws_api_gateway_resource" "lambda_resource" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
#   path_part   = "lambda"
# }

# resource "aws_api_gateway_method" "lambda_method" {
#   rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
#   resource_id   = aws_api_gateway_resource.lambda_resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda_integration" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   resource_id = aws_api_gateway_resource.lambda_resource.id
#   http_method = aws_api_gateway_method.lambda_method.http_method

#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.bid_lambda_fn.invoke_arn
# }

# resource "aws_api_gateway_deployment" "lambda_deployment" {
#   depends_on  = [aws_api_gateway_integration.lambda_integration]
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   stage_name  = "dev"
# }
