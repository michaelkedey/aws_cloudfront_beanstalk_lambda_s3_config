# dev.tfvars
bucket_name = "myoneandonly-dev-bucket"
# bucket2_name = "appdev-versions"
app_name = "dev-sample_app"
max_instance = 2
min_instance = 1
root_vol_type = "gp2"
root_vol_size = 30
beanstalk_env_name = "my-dev-beanstalk10"
instance_type = "t2.micro"
version_name = "version0.0.1"

#backend
# bucket = "web-pro-bucket"
# key    = "dev/terraform.tfstate"
# region = "us-east-1"

