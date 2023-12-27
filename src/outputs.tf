# # #s3
# output "bucket_name" {
#   value = module.primary_bucket.bucket_name
# }

output "bucket_arn" {
  value = module.primary_bucket.bucket_arn
}

# output "bucket_domain_name" {
#   value = module.primary_bucket.bucket_domain_name
# }

# output "bucket_id" {
#   value = module.primary_bucket.bucket_id
# }

# # output "static_site_dns" {
# #   value = module.primary_bucket.static_site_dns
# # }


# # #cf
# # output "cloudfront_domain_name" {
# #   value = module.cf.cloudfront_domain_name
# # }

# # # output "cloudfront_distribution_id" {
# # #   value = module.cf.cloudfront_distribution_id
# # # }

# # # output "cloudfront_status" {
# # #   value = module.cf.cloudfront_status
# # # }

# # # output "cloudfront_arn" {
# # #   value = module.cf.cloudfront_arn

# # # }

# # # output "cloudfront_caching_behavior" {
# # #   value = module.cf.cloudfront_caching_behavior
# # # }

# # output "cloudfront_viewer_certificate" {
# #   value = module.cf.cloudfront_viewer_certificate
# # }


# # #vpc
# # #vpc_id
# # output "vpc_id" {
# #   value = module.vpc.vpc_id
# # }

# # #subnet_ids
# # output "sn_private1_id" {
# #   value = module.vpc.sn_private1_id
# # }

# # output "sn_private2_id" {
# #   value = module.vpc.sn_private2_id
# # }

# # output "sn_public1_id" {
# #   value = module.vpc.sn_public1_id
# # }

# # output "sn_public2_id" {
# #   value = module.vpc.sn_public2_id
# # }

# # #sg_ids
# # output "beanstalk_sg_id" {
# #   value     = module.vpc.beanstalk_sgs
# #   sensitive = true
# # }

# # output "lb_sg_id" {
# #   value = module.vpc.lb_sg_id
# # }

# # # #rt_ids
# # # output "public_rt_id" {
# # #   value = aws_route_table.bid_public_rt.id
# # # }

# # # output "private_rt_id" {
# # #   value = aws_route_table.bid_private_rt.id
# # # }

# # # #igw_id
# # # output "internet_gateway_id" {
# # #   value = aws_internet_gateway.bid_gw.id
# # # }

# # # #ngw_id
# # # output "nat_gateway_ids" {
# # #   value = aws_nat_gateway.bid_ngw.id
# # # }

# # #lb
# # output "load_balancer" {
# #   value = module.vpc.load_balancer
# # }

# # #beanstalk instances usbnets
# # output "beanstalk_subnets" {
# #   value = join(",", [module.vpc.sn_private1_id, module.vpc.sn_private2_id])
# # }

# # output "app_or_function_output_path" {
# #   value = module.archive_files.app_or_function_output_path
# # }

# # output "src_code_hash" {
# #   value = module.archive_files.src_code_hash
# # }



# # #beanstalk
# # # output "environment_id" {
# # #   value = module.beanstalk.environment_id
# # # }

# # # output "environment_name" {
# # #   value = module.beanstalk.environment_name
# # # }

# # # output "instance_ids" {
# # #   value = module.beanstalk.instance_ids
# # # }

#lambda api
output "lambda_api_url" {
  value = module.lambda.lambda_api_url
}

# output "instance_ids" {
#   value = module.beanstalk.instance_ids
# }

output "cname" {
  value = module.beanstalk.c_name
}