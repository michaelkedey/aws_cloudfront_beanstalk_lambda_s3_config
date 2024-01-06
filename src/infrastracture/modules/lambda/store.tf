# resource "aws_ssm_parameter" "lambda_api_url" {
#   name  = "/bid/lambda_api_url"
#   type  = "String"
#   value = aws_api_gateway_deployment.lambda_deployment.invoke_url
#   #depends_on = [aws_elastic_beanstalk_application.bid_app]
# }