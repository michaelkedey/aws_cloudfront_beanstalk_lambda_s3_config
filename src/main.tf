#create primary bucket
module "primary_bucket" {
  source = "./modules/s3"
  name   = "only_one_static_primarybucket"

}

#create cloudfront distribution
module "cf" {
  source                      = "./modules/cloudfront"
  primary_bucket_domain_name  = module.primary_bucket.bucket_domain_name
}

#create and attache cf bucket policy
module "cf_s3_policy_primary" {
  source                      = "./modules/cf_bkt_policy"
  bucket_id_to_attache_policy = module.primary_bucket.bucket_id
  cloudfront_arn              = module.cf.cloudfront_arn
  bucket_arn                  = module.primary_bucket.bucket_arn
}

# #create and attache bucket policy
# module "cf_s3_policy_failover" {
#   source                      = "./modules/cf_bkt_policy"
#   bucket_id_to_attache_policy = module.failover_bucket.bucket_id
#   cloudfront_arn              = module.cf.cloudfront_arn
#   bucket_arn                  = module.failover_bucket.bucket_arn
# }



