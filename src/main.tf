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


#4 upload lambda function to bucket
module "upload_lambda" {
  source       = "./modules/bucket_uploads"
  file_path    = "./s3_uploads/zipped_functions/name_form.js.zip" #module.archive_files.app_or_function_output_path
  s3_bucket_id = module.primary_bucket.bucket_id
  key          = "name_form.js.zip"
}


#create empty lb, necesarry for the beanstalk
module "emptylb" {
  source   = "./modules/loadbalancer/empty_lb"
  subnets  = module.vpc.vpc_sns
  vpc_cidr = module.vpc.vpc_id
}


#2 create vpc with empty lb id
module "vpc" {
  source = "./modules/vpc"
  lb_sg  = module.emptylb.empty_lb_sg_id
}


#5 create lambda_fn from s3 
module "lambda" {
  source         = "./modules/lambda"
  vpc_subnet_ids = split(",", module.vpc.beanstalk_subnets)
  bucket_arn     = module.primary_bucket.bucket_arn
  #event_source_arn = module.primary_bucket.bucket_arn
  bucket_name = module.primary_bucket.bucket_name
  #src_file = module.archive.app_or_function_output_path
  lambda_file         = "../../s3_uploads/zipped_functions/name_form.js.zip"
  src_code_hash       = module.zip_lambda.src_code_hash
  security_group_ids  = [module.vpc.beanstalk_sg_id]
  lambda_func_handler = "index.handler"
}


#####################################################################

#6 archive .net app after inserting lambda api url in code
module "zip_dotnet" {
  source      = "./modules/build_directory"
  src_path    = "../../functions/dotnet/LambdaWebApp"
  output_path = "../../s3_uploads/zipped_functions/LambdaWebApp"
}


#upload .net function to bucket
module "upload_dot_net" {
  source       = "./modules/bucket_uploads"
  file_path    = "./s3_uploads/zipped_functions/LambdaWebApp.zip" #module.archive_files.app_or_function_output_path
  s3_bucket_id = module.primary_bucket.bucket_id
  key          = "LambdaWebApp.zip"
}


#6 create beanstalk env with dotnet app
module "beanstalk" {
  source               = "./modules/beanstalk/prod"
  instance_type        = "t2.micro"
  max_instances        = 3
  min_instances        = 2
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.beanstalk_subnets
  application_name     = module.dotnet_app.app_name
  lb_name              = module.emptylb.empty_lb_arn
  lambda_function_name = "name_form.js.zip"
  sgs                  = module.vpc.beanstalk_sg_id
  app_key              = "LambdaWebApp.zip"
  root_volume_size     = 8
  root_volume_type     = "gp2"
}


#create dotnet app
module "dotnet_app" {
  source           = "./modules/app_version"
  bucket_name      = module.primary_bucket.bucket_id
  app_key          = "LambdaWebApp.zip"
  app_version_name = "LambdaWebApp.zip"
}


#deploy 
# module "load_balancer" {
#   source          = "./modules/loadbalancer"
#   vpc_id          = module.vpc.vpc_id
#   subnet_for_lbs  = module.vpc.beanstalk_subnets
#   lb_egress_cidrs = module.vpc.lb_out_cidrs
#   beanstalk_sg    = module.vpc.beanstalk_sg_id
#   instance_ids    = module.beanstalk.instance_ids
# }


#create cloudfront distribution
# module "cf" {
#   source             = "./modules/cloudfront"
#   bucket_domain_name = module.primary_bucket.bucket_domain_name
#   cf_origin_id       = module.primary_bucket.bucket_name
# }


#############################################################################

# module "upload_html_files" {
#   source       = "./modules/bucket_uploads"
#   file_path    = "../../s3_uploads/html" #module.archive_files.app_or_function_output_path
#   s3_bucket_id = module.primary_bucket.bucket_id
# }


# #create and attach cf bucket policy
# module "cf_s3_policy" {
#   source                      = "./modules/cf_bkt_policy"
#   bucket_id_to_attache_policy = module.primary_bucket.bucket_id
#   cloudfront_arn              = module.cf.cloudfront_arn
#   bucket_arn                  = module.primary_bucket.bucket_arn
# }









