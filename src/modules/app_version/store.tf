resource "aws_ssm_parameter" "app_name" {
  name  = "/bid/app_name"
  type  = "String"
  value = aws_elastic_beanstalk_application.bid_app.name
  #depends_on = [aws_elastic_beanstalk_application.bid_app]
}


resource "aws_ssm_parameter" "app_version_label" {
  name  = "/bid/app_version_label"
  type  = "String"
  value = aws_elastic_beanstalk_application_version.bid_app_version.name

}
