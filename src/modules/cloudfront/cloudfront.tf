#cloudfront origin access
resource "aws_cloudfront_origin_access_control" "bid_cf_s3_oac" {
  name                              = var.cf_oac
  description                       = var.cf_description
  origin_access_control_origin_type = var.oac_type
  signing_behavior                  = var.signing_behavior
  signing_protocol                  = var.signing_protocol
}

#cloudfront distribution
resource "aws_cloudfront_distribution" "bid_distribution" {
  origin {

    domain_name              = var.bucket_domain_name
    origin_id                = var.cf_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.bid_cf_s3_oac.id
  }

  #uncomment code below to set 2 origin buckets for cf
  # origin {
  #   domain_name = var.failover_bucket_domain_name
  #   origin_id   = var.cf_origin_id[1]

  #   origin_access_control_id = aws_cloudfront_origin_access_control.bid_cf_s3_oac.id

  # }

  enabled = var.cf_enabled

  default_cache_behavior {
    allowed_methods  = var.methods
    cached_methods   = var.methods
    target_origin_id = var.cf_origin_id #change to dist id when you have multiple origins in origin group

    forwarded_values {
      query_string = var.query_string
      headers      = var.cf_forward_headers
      cookies {
        forward = var.cf_forward_cookies
      }
    }

    viewer_protocol_policy = var.cf_viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.def_ttl
    max_ttl                = var.max_ttl
  }

  viewer_certificate {
    cloudfront_default_certificate = var.cf_def_cert
  }
  #   custom ssl cert
  #   viewer_certificate {
  #     acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-abcd-1234-abcd-1234abcd5678"
  #     ssl_support_method  = "sni-only"
  #   }

  restrictions {
    geo_restriction {
      restriction_type = var.cf_restriction_type
      locations        = var.cf_restriction_list
    }
  }

  # logging_config {
  #   bucket          = var.primary_bucket_domain_name
  #   include_cookies = var.log_cookies
  #   prefix          = var.cf_logs_prefix
  # }

  #web_acl_id = aws_wafregional_web_acl.example.id
  #implement waf later

  #uncomment when you have 2 or more origins and modify appropriately
  # origin_group {
  #   origin_id = var.cf_target_origin_id

  #   member {
  #     origin_id = var.cf_origin_id[0]
  #   }

  #   member {
  #     origin_id = var.cf_origin_id[1]
  #   }

  #   failover_criteria {
  #     status_codes = var.cf_failover_status_codes
  #   }
  # }


}

