#create primary bucket
module "primary_bucket" {
  source      = "./../src/modules/s3"
  name = "only_one_static_primarybucket"

}

#create failover_bucket
module "failover_bucket" {
  source      = "./../src/modules/s3"
  name = "my_onlystatic_failoverbucket"
  
}

#create cloudfront distribution
module "cloudfront" {
  source = "../../src/modules/cloudfront"
  
  depends_on = [
    module.primary_bucket,
    module.failover_bucket
  ]
}

#create a vpc
module "vpc" {
  source = "../../src/modules/vpc"
  instance_ids = []
}


