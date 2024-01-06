#1 create vpc 
module "vpc" {
  source = "./modules/vpc"

}

#2 create bucket
module "bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

#3 archive lambda functions
module "zip_lambda" {
  source      = "./modules/archive_file"
  src_file    = var.lambda_archive_source
  output_path = var.lambda_archive_output
}

#4 upload lambda function to bucket
module "upload_lambda" {
  source       = "./modules/bucket_uploads_file"
  file_path    = var.lambda_file_upload
  s3_bucket_id = module.bucket.bucket_id
  key          = var.lambda_key
}

#5 upload .net function to bucket
module "upload_dot_net" {
  source       = "./modules/bucket_uploads_file"
  file_path    = var.app_file_upload
  s3_bucket_id = module.bucket.bucket_id
  key          = var.app_key
}

#6 create lambda_fn from s3 
module "lambda" {
  source         = "./modules/lambda"
  vpc_subnet_ids = split(",", module.vpc.beanstalk_subnet_lists)
  #event_source_arn = module.primary_bucket.bucket_arn
  s3_bucket_name     = module.bucket.bucket_name
  lambda_file        = "../../s3_uploads/name_form.js.zip" #var.lambda_file_upload
  src_code_hash      = module.zip_lambda.src_code_hash
  security_group_ids = [module.vpc.beanstalk_sg_id]
  eb_app_name        = module.dotnet_app.app_name
  eb_env_name        = module.beanstalk.environment_name
  prefix             = var.prefix
  suffix             = var.suffix
}

#7 create dotnet app
module "dotnet_app" {
  source   = "./modules/app"
  app_name = var.app_name

}

#8 create beanstalk env with dotnet app after inserting the s3 arn into the policies
module "beanstalk" {
  source               = "./modules/beanstalk/prod"
  instance_type        = var.instance_type
  max_instances        = var.max_instance
  min_instances        = var.min_instance
  root_volume_size     = var.root_vol_size
  root_volume_type     = var.root_vol_type
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.beanstalk_subnet_lists
  s3_logs_bucket_id    = module.bucket.bucket_id
  s3_logs_bucket_name  = module.bucket.bucket_name
  elb_subnet_ids       = module.vpc.beanstalk_lb_subnet_lists
  lambda_function_name = var.lambda_key
  beanstalk_name       = var.beanstalk_env_name
  application_name     = module.dotnet_app.app_name
  #sgs                  = module.vpc.beanstalk_sgs
  #lb_name              = module.load_balancer.lb_arn
  #lb_arn               = module.load_balancer.lb_arn
  #app_version_name     = module.dotnet_app_version.beanstalk_app_version_label

}

# #9 trigger lambda
# module "trigger_lambda_via_upload" {
#   source       = "./modules/bucket_uploads_file"
#   file_path    = var.app_file_trigger_upload
#   s3_bucket_id = module.bucket.bucket_id
#   key          = var.app_file_trigger_key
# }


# ########################################################################

#9 create dotnet app version
# module "dotnet_app_version" {
#   source           = "./modules/app_version"
#   app_key          = var.app_key
#   app_version_name = var.version_name
#   bucket_id        = module.bucket.bucket_id
#   application = module.dotnet_app.app_name

# }

#4 archive .net app directory
# module "zip_dotnet" {
#   source      = "./modules/archive_dir"
#   src_path    = var.app_archive_source
#   output_path = var.app_archive_output
# }


# #11 deploy lb
# # module "load_balancer" {
# #   source = "./modules/loadbalancer"
# #   vpc_id = module.vpc.vpc_id
# #   subnet_for_lbs = [
# #     module.vpc.sn_public1_id,
# #     module.vpc.sn_public2_id
# #   ]
# #   lb_egress_cidrs = module.vpc.lb_out_cidrs
# #   beanstalk_sg    = module.vpc.beanstalk_sg_id
# #   #instance_ids    = module.beanstalk.instance_ids
# #   #lb_egress_cidrs = split(",",module.vpc.lb_out_cidrs)
# # }


# #12create cloudfront distribution
# # module "cf" {
# #   source             = "./modules/cloudfront"
# #   bucket_domain_name = module.primary_bucket.bucket_domain_name
# #   cf_origin_id       = module.primary_bucket.bucket_name
# # }


# #13 #create and attach cf bucket policy
# # module "cf_s3_policy" {
# #   source                      = "./modules/cf_bkt_policy"
# #   bucket_id_to_attache_policy = module.primary_bucket.bucket_id
# #   cloudfront_arn              = module.cf.cloudfront_arn
# #   bucket_arn                  = module.primary_bucket.bucket_arn
# # }

###

