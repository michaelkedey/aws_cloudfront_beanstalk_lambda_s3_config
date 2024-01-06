#cloudfront origin access
variable "cf_oac" {
  default = "bid_cf_S3_oac"
  type    = string
}

variable "cf_description" {
  default = "Cloud Front S3 OAC"
  type    = string
}

variable "oac_type" {
  default = "s3"
  type    = string
}

variable "signing_behavior" {
  default = "always"
  type    = string
}

variable "signing_protocol" {
  default = "sigv4"
  type    = string
}


#placeholder
variable "bucket_domain_name" {}

#uncomment when you have multiple origins
#variable "failover_bucket_domain_name" {}

#placeholder
#variable "cf_origin_id" {}

variable "cf_enabled" {
  default     = true
  type        = bool
  description = "enable cf"
}

variable "methods" {
  default = ["GET", "HEAD"]
  type    = list(any)
}

variable "cf_target_origin_id" {
  default = "bid_cf_distribution"
  type    = string
}

variable "query_string" {
  default = true
  type    = bool

}

variable "cf_forward_headers" {
  default = ["Origin", "Access-Control-Request-Headers"]
  type    = list(any)

}

variable "cf_forward_cookies" {
  default = "none"
  type    = string
}

variable "cf_viewer_protocol_policy" {
  default = "allow-all"
  type    = string

}

variable "min_ttl" {
  default = 0
  type    = number

}

variable "def_ttl" {
  default = 3600
  type    = number

}

variable "max_ttl" {
  default = 86400
  type    = number

}

variable "cf_def_cert" {
  default = true

}

variable "cf_restriction_type" {
  default = "whitelist"
  type    = string

}

variable "cf_restriction_list" {
  default = ["US", "CA", "GH"]
  type    = list(any)

}

variable "log_cookies" {
  default = false
  type    = bool
}

variable "cf_logs_prefix" {
  default = "bid_cloudfront-logs/"
  type    = string
}

variable "cf_failover_status_codes" {
  default = [0, 1, 2, 3, 4, 5, 6]
  type    = list(any)

}

#placeholder
variable "cf_origin_id" {}