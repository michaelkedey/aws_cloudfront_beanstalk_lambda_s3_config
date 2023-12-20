output "bucket_name" {
  value = aws_s3_bucket.bid_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.bid_bucket.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.bid_bucket.bucket_regional_domain_name
}

output "bucket_id" {
  value = aws_s3_bucket.bid_bucket.id
}

