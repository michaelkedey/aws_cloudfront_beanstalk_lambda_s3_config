resource "aws_elastic_beanstalk_application_version" "bid_app_version" {
  application = var.application
  bucket      = var.bucket_id
  name        = var.app_version_name
  key         = var.app_key

}




