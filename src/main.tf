#1 create vpc 
module "vpc" {
  source = "./modules/vpc"

}

#2 create bucket
module "bucket" {
  source      = "./modules/s3"
  bucket_name = "myoneandonlyconsortium"

}

#3 archive lambda functions
module "zip_lambda" {
  source      = "./modules/archive_file"
  src_file    = "../../functions/lambda/name_form.js"
  output_path = "../../s3_uploads/name_form.js"
}

#4 archive .net app directory
# module "zip_dotnet" {
#   source      = "./modules/build_directory"
#   src_path    = "../../functions/dotnet/LambdaWebApp"
#   output_path = "../../s3_uploads/LambdaWebApp"
# }


#5 upload lambda function to bucket
module "upload_lambda" {
  source       = "./modules/bucket_uploads_file"
  file_path    = "./s3_uploads/name_form.js.zip"
  s3_bucket_id = module.bucket.bucket_id
  key          = "name_form.js.zip"
}

#6 upload .net function to bucket
module "upload_dot_net" {
  source       = "./modules/bucket_uploads_file"
  file_path    = "./s3_uploads/LambdaWebApp2.zip"
  s3_bucket_id = module.bucket.bucket_id
  key          = "LambdaWebApp2.zip"
}

#7 create lambda_fn from s3 
module "lambda" {
  source         = "./modules/lambda"
  vpc_subnet_ids = split(",", module.vpc.beanstalk_subnet_lists)
  #event_source_arn = module.primary_bucket.bucket_arn
  bucket_name         = module.bucket.bucket_name
  lambda_file         = "../../s3_uploads/name_form.js.zip"
  src_code_hash       = module.zip_lambda.src_code_hash
  security_group_ids  = [module.vpc.beanstalk_sg_id]
  lambda_func_handler = "index.handler"
}

#8 create dotnet app
module "dotnet_app" {
  source   = "./modules/app"
  app_name = "sample_app"

}

#9 create dotnet app version
# module "dotnet_app_version" {
#   source           = "./modules/app_version"
#   app_key          = "LambdaWebApp2.zip"
#   app_version_name = "version0.0.1"
#   bucket_id        = module.bucket.bucket_id
#   application = module.dotnet_app.app_name

# }

#10 create beanstalk env with dotnet app after inserting the s3 arn into the policies
module "beanstalk" {
  source               = "./modules/beanstalk/prod"
  instance_type        = "t3.micro"
  max_instances        = 3
  min_instances        = 1
  root_volume_size     = 30
  root_volume_type     = "gp2"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.beanstalk_subnet_lists
  s3_logs_bucket_id    = module.bucket.bucket_id
  s3_logs_bucket_name  = module.bucket.bucket_name
  elb_subnet_ids       = module.vpc.beanstalk_lb_subnet_lists
  lambda_function_name = "name_form.js.zip"
  beanstalk_name       = "my-prod-beanstalk10"
  application_name     = module.dotnet_app.app_name
  #sgs                  = module.vpc.beanstalk_sgs
  #lb_name              = module.load_balancer.lb_arn
  #lb_arn               = module.load_balancer.lb_arn
  #app_version_name     = module.dotnet_app_version.beanstalk_app_version_label

}


# ########################################################################

# #4 deploy lb
# # module "load_balancer" {
# #   source = "./modules/loadbalancer"
# #   vpc_id = module.vpc.vpc_id
# #   subnet_for_lbs = [
# #     module.vpc.sn_public1_id,
# #     module.vpc.sn_public2_id
# #   ]
# #   lb_egress_cidrs = module.vpc.lb_out_cidrs
# #   beanstalk_sg    = module.vpc.beanstalk_sg_id
# #   dot_net_port = 5204
# #   #instance_ids    = module.beanstalk.instance_ids
# #   #lb_egress_cidrs = split(",",module.vpc.lb_out_cidrs)
# # }



# #create cloudfront distribution
# # module "cf" {
# #   source             = "./modules/cloudfront"
# #   bucket_domain_name = module.primary_bucket.bucket_domain_name
# #   cf_origin_id       = module.primary_bucket.bucket_name
# # }


# # #create and attach cf bucket policy
# # module "cf_s3_policy" {
# #   source                      = "./modules/cf_bkt_policy"
# #   bucket_id_to_attache_policy = module.primary_bucket.bucket_id
# #   cloudfront_arn              = module.cf.cloudfront_arn
# #   bucket_arn                  = module.primary_bucket.bucket_arn
# # }









