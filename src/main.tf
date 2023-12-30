#1 create bucket
module "primary_bucket" {
  source      = "./modules/s3"
  bucket_name = "myoneandonlystaticbucket"

}


#2 archive lambda functions
module "zip_lambda" {
  source      = "./modules/build_file"
  src_file    = "../../functions/lambda/name_form.js"
  output_path = "../../s3_uploads/zipped_functions/name_form.js"
}


# #3 archive .net app directory
# module "zip_dotnet" {
#   source      = "./modules/build_directory"
#   src_path    = "../../functions/dotnet/LambdaWebApp"
#   output_path = "../../s3_uploads/zipped_functions/LambdaWebApp"
# }

#3 archive .net app directory
# module "zip_dotnet" {
#   source           = "./modules/build_directory"
#   src_path         = "../../functions/dotnet/LambdaWebApp/site"
#   output_path_dir  = "../../s3_uploads/zipped_functions/LambdaWebApp/site"
#   src_file         = "../../functions/dotnet/LambdaWebApp/aws-windows-deployment-manifest.json"
#   output_path_file = "../../s3_uploads/zipped_functions/LambdaWebApp/aws-windows-deployment-manifest.json"
# }

# #4bundle dotnet
# module "bundle_dotnet" {
#   source      = "./modules/bundle_directory"
#   src_path    = "../../s3_uploads/zipped_functions/LambdaWebApp"
#   output_path = "../../s3_uploads/zipped_functions/LambdaWebApp"
# }



#5 upload lambda function to bucket
module "upload_lambda" {
  source       = "./modules/bucket_uploads"
  file_path    = "./s3_uploads/zipped_functions/name_form.js.zip" #module.archive_files.app_or_function_output_path
  s3_bucket_id = module.primary_bucket.bucket_id
  key          = "name_form.js.zip"
}


# #6 upload .net function to bucket
# module "upload_dot_net" {
#   source       = "./modules/bucket_uploads"
#   file_path    = "./s3_uploads/zipped_functions/LambdaWebApp.zip" #module.archive_files.app_or_function_output_path
#   s3_bucket_id = module.primary_bucket.bucket_id
#   key          = "LambdaWebApp.zip"
# }


#6 upload .net function to bucket
module "upload_dot_net" {
  source       = "./modules/bucket_uploads"
  file_path    = "./functions/dotnet/LambdaWebApp/LambdaWebApp.zip" #module.archive_files.app_or_function_output_path
  s3_bucket_id = module.primary_bucket.bucket_id
  key          = "LambdaWebApp.zip"
}


#7 create vpc 
module "vpc" {
  source = "./modules/vpc"
  #lb_sg  = toset(module.load_balancer.lb_sg_id)
  dot_net_port = 5204
}


#8 create lambda_fn from s3 
module "lambda" {
  source         = "./modules/lambda"
  vpc_subnet_ids = split(",", module.vpc.beanstalk_subnet_lists) #split(",", module.vpc.beanstalk_subnets)
  bucket_arn     = module.primary_bucket.bucket_arn
  #event_source_arn = module.primary_bucket.bucket_arn
  bucket_name         = module.primary_bucket.bucket_name
  lambda_file         = "../../s3_uploads/zipped_functions/name_form.js.zip"
  src_code_hash       = module.zip_lambda.src_code_hash
  security_group_ids  = [module.vpc.beanstalk_sg_id]
  lambda_func_handler = "index.handler"
}


#9 create dotnet app
module "dotnet_app" {
  source           = "./modules/app_version"
  bucket_name      = module.primary_bucket.bucket_id
  app_key          = "LambdaWebApp.zip"
  app_version_name = "LambdaWebApp.zip"
}


#10 create beanstalk env with dotnet app after inserting the s3 arn into the policies
module "beanstalk" {
  source           = "./modules/beanstalk/prod"
  instance_type    = "t3.micro"
  max_instances    = 3
  min_instances    = 2
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.beanstalk_subnet_lists
  application_name = module.dotnet_app.app_name
  #lb_name              = module.load_balancer.lb_arn
  lambda_function_name = "name_form.js.zip"
  #sgs                  = module.vpc.beanstalk_sgs
  app_key          = module.dotnet_app.beanstalk_app_version_label #module.upload_dot_net.dotnet_id #"LambdaWebApp.zip"
  root_volume_size = 30
  root_volume_type = "gp2"
  s3_app_id        = module.upload_dot_net.dotnet_id
  #lb_arn               = module.load_balancer.lb_arn
  s3_logs_bucket_id   = module.primary_bucket.bucket_id
  s3_logs_bucket_name = module.primary_bucket.bucket_name
  elb_subnet_ids      = module.vpc.beanstalk_lb_subnet_lists
  beanstalk_name      = "my-prod-beanstalk7"

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









