#create primary bucket
module "primary_bucket" {
  source = "./modules/s3"
  name   = "onlyonestaticprimarybucket"

}

#create vpc
module "vpc" {
  source       = "./modules/vpc"
  instance_ids = module.beanstalk.instance_ids
}

#create lambda_f
module "lambda" {
  source             = "./modules/lambda"
  sceurity_group_ids = [module.vpc.beanstalk_sg_id]
  vpc_subnet_ids     = [module.vpc.sn_private1_id, module.vpc.sn_private2_id]
  bucket_arn         = module.primary_bucket.bucket_arn
  event_source_arn   = module.primary_bucket.bucket_arn
  bucket_name        = module.primary_bucket.bucket_name

}

#create beanstalk env
module "beanstalk" {
  source        = "./modules/beanstalk/prod"
  instance_type = "t2-micro"
  max_instances = 3
  min_instances = 2
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = [module.vpc.sn_private1_id, module.vpc.sn_private2_id]

}

# #create cloudfront distribution
# module "cf" {
#   source                     = "./modules/cloudfront"
#   primary_bucket_domain_name = module.primary_bucket.bucket_domain_name
# }

#create and attache cf bucket policy
# module "cf_s3_policy_primary" {
#   source                      = "./modules/cf_bkt_policy"
#   bucket_id_to_attache_policy = module.primary_bucket.bucket_id
#   cloudfront_arn              = module.cf.cloudfront_arn
#   bucket_arn                  = module.primary_bucket.bucket_arn
# }

# #create and attache bucket policy
# module "cf_s3_policy_failover" {
#   source                      = "./modules/cf_bkt_policy"
#   bucket_id_to_attache_policy = module.failover_bucket.bucket_id
#   cloudfront_arn              = module.cf.cloudfront_arn
#   bucket_arn                  = module.failover_bucket.bucket_arn
# }



