output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.bid_distribution.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.bid_distribution.id
}

output "cloudfront_status" {
  value = aws_cloudfront_distribution.bid_distribution.status
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.bid_distribution.arn

}
output "cloudfront_caching_behavior" {
  value = aws_cloudfront_distribution.bid_distribution.default_cache_behavior
}
output "cloudfront_viewer_certificate" {
  value = aws_cloudfront_distribution.bid_distribution.viewer_certificate
}
