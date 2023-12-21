#s3
output "bucket_name" {
  value = module.primary_bucket.bucket_name
}

output "bucket_arn" {
  value = module.primary_bucket.bucket_arn
}

output "bucket_domain_name" {
  value = module.primary_bucket.bucket_domain_name
}

output "bucket_id" {
  value = module.primary_bucket.bucket_id
}

output "static_site_dns" {
  value = module.primary_bucket.static_site_dns
}


#cf
output "cloudfront_domain_name" {
  value = module.cf.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  value = module.cf.cloudfront_distribution_id
}

output "cloudfront_status" {
  value = module.cf.cloudfront_status
}

output "cloudfront_arn" {
  value = module.cf.cloudfront_arn

}
output "cloudfront_caching_behavior" {
  value = module.cf.cloudfront_caching_behavior
}
output "cloudfront_viewer_certificate" {
  value = module.cf.cloudfront_viewer_certificate
}

