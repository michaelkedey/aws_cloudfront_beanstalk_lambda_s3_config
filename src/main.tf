#create primary bucket
module "primary_bucket" {
  source      = "./modules/s3"
  bucket_name = "myoneandonlystaticbucket"

}

#archive and upload function
module "archive_files" {
  source   = "./modules/app_build"
  src_file = "../../functions/name_form.js"
}

module "upload" {
  source       = "./modules/bucket_uploads"
  file_path    = "../../functions/name_form.js.zip" #module.archive_files.app_or_function_output_path
  s3_bucket_id = module.primary_bucket.bucket_id
}

# #create lambda_f
module "lambda" {
  source           = "./modules/lambda"
  vpc_subnet_ids   = toset([module.vpc.sn_private1_id])
  bucket_arn       = module.primary_bucket.bucket_arn
  event_source_arn = module.primary_bucket.bucket_arn
  bucket_name      = module.primary_bucket.bucket_name
  #src_file = module.archive.app_or_function_output_path
  src_file_zip       = module.archive_files.app_or_function_output_path
  src_code_hash      = module.archive_files.src_code_hash
  security_group_ids = toset([module.vpc.beanstalk_sg_id])
}

#create cloudfront distribution
module "cf" {
  source             = "./modules/cloudfront"
  bucket_domain_name = module.primary_bucket.bucket_domain_name
  cf_origin_id       = module.primary_bucket.bucket_name
}

# #create and attach cf bucket policy
module "cf_s3_policy" {
  source                      = "./modules/cf_bkt_policy"
  bucket_id_to_attache_policy = module.primary_bucket.bucket_id
  cloudfront_arn              = module.cf.cloudfront_arn
  bucket_arn                  = module.primary_bucket.bucket_arn
}

#create vpc
module "vpc" {
  source       = "./modules/vpc"
  instance_ids = module.beanstalk.instance_ids
}

# #create beanstalk env
module "beanstalk" {
  source        = "./modules/beanstalk/prod"
  instance_type = "t2-micro"
  max_instances = 3
  min_instances = 2
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.beanstalk_subnets
  #app_key              = "name_form.js.zip"
  lb_name              = module.vpc.load_balancer
  bucket_name          = module.primary_bucket.bucket_name
  lambda_function_name = module.archive_files.app_or_function_output_path
  sgs                  = module.vpc.beanstalk_sg_id
}


# # #create and attach bucket policy
# # module "cf_s3_policy_failover" {
# #   source                      = "./modules/cf_bkt_policy"
# #   bucket_id_to_attache_policy = module.failover_bucket.bucket_id
# #   cloudfront_arn              = module.cf.cloudfront_arn
# #   bucket_arn                  = module.failover_bucket.bucket_arn
# # }



