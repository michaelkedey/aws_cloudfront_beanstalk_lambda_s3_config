# resource "aws_elastic_beanstalk_application_version" "my_app_version" {
#   application = aws_elastic_beanstalk_application.my_app.name
#   description = "My application version"
#   bucket      = "my-app-bucket"
#   key         = "application.zip"
#   name = "myapp"
# }

resource "aws_elastic_beanstalk_application" "bid_app" {
  name = var.app_name
}

resource "aws_elastic_beanstalk_application_version" "bid_app_version" {
  bucket      = var.bucket_name
  name        = var.app_name
  application = aws_elastic_beanstalk_application.bid_app.id
  key         = var.app_key

}


