data "aws_caller_identity" "current" {}

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

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "lambda_execution_policy-2"
  description = "Policy for Lambda execution role"
  policy      = file("${path.module}/lambda_execution_policy.json")

}

resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy_attachment-2" {
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_role_policy_attachment" "lerpa2" {
  policy_arn = var.lambda_policy_arn
  role       = aws_iam_role.lambda_execution_role.name
}


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
      REGION              = var.region
    }
  }

  #vpc to deploy in
  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.vpc_subnet_ids
  }

  tracing_config {
    mode = var.tracing_mode
  }
  tags = var.lambda_tags
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bid_lambda_fn.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_arn
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = var.s3_bucket_id
  lambda_function {
    lambda_function_arn = aws_lambda_function.bid_lambda_fn.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
