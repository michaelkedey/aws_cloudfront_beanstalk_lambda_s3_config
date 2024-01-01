resource "aws_elastic_beanstalk_application" "bid_app" {
  name = var.app_name
}

resource "aws_elastic_beanstalk_application_version" "bid_app_version" {
  bucket      = var.bucket_id
  name        = var.app_version_name
  application = aws_elastic_beanstalk_application.bid_app.name
  key         = var.app_key

}




