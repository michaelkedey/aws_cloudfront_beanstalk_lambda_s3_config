output "bucket_arn" {
  value = module.bucket.bucket_arn
}

output "cname" {
  value = module.beanstalk.c_name
}