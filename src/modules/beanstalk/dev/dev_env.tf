resource "aws_elastic_beanstalk_environment" "dev" {
  name                = var.env[0]
  application         = aws_elastic_beanstalk_application.bid_app
  solution_stack_name = var.stack["windowsa"]
  tier                = var.env_tier[0]

}