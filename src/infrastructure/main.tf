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
  source       = "./modules/file_upload"
  file_path    = var.lambda_file_upload
  s3_bucket_id = module.bucket.bucket_id
  key          = var.lambda_key
}

#5 upload .net function to bucket
module "upload_dot_net" {
  source       = "./modules/file_upload"
  file_path    = var.app_file_upload
  s3_bucket_id = module.bucket.bucket_id
  key          = var.app_key
}

#6 create lambda_fn from s3 
module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = "my_lambda"
  lambda_file          = "../../s3_uploads/auto_deploy_function.py.zip"
  vpc_subnet_ids       = split(",", module.vpc.beanstalk_subnet_lists)
  s3_bucket_name       = module.bucket.bucket_name
  eb_app_name          = module.dotnet_app.app_name
  security_group_ids   = [module.vpc.beanstalk_sg_id]
  s3_arn               = module.bucket.bucket_arn
  s3_bucket_id         = module.bucket.bucket_id
  src_code_hash        = module.zip_lambda.src_code_hash
  eb_env_name          = module.beanstalk.environment_name

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

#route 53
# module "route53" {
#   source = "../modules/route53"
#   vpc_id = module.vpc.vpc_id
#   beanstalk_elb_dns = module.beanstalk.c_name
# }


