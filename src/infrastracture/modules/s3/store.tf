resource "aws_ssm_parameter" "bucket_name" {
  name  = "/bid/s3_bucket_name"
  type  = "String"
  value = aws_s3_bucket.bid_bucket.bucket

}

resource "aws_ssm_parameter" "bucket_id" {
  name  = "/bid/s3_bucket_id"
  type  = "String"
  value = aws_s3_bucket.bid_bucket.id

}

resource "aws_ssm_parameter" "bucket_arn" {
  name  = "/bid/s3_bucket_arn"
  type  = "String"
  value = aws_s3_bucket.bid_bucket.arn

}
