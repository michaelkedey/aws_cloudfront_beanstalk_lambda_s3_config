output "app_name" {
  value = aws_elastic_beanstalk_application.bid_app.name
}

output "beanstalk_app_version_label" {
  value = aws_elastic_beanstalk_application_version.bid_app_version.name
}