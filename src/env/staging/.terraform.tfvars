#staging.tfvars
bucket_name = "myoneandonlystagingbucket"
bucket2_name = "appstaging-versions"
app_name = "staging-sample_app"
max_instance = 4
min_instance = 2
root_vol_type = "gp2"
root_vol_size = 30
beanstalk_env_name = "my-staging-beanstalk10"
instance_type = "t3.micro"
version_name = "version0.0.1"

#backend
# bucket = "hadari-africa-staging-bucket"
# key    = "staging/terraform.tfstate"
# region = "us-east-1"




