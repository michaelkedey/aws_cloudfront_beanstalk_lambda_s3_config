# terraform {
#     backend "s3" {
#     #bucket exists already prod
#     bucket = "hadari-africa-staging-bucket"
#     key    = "staging/terraform.tfstate"
#     region = "us-east-1"

#   }
# }

bucket = "hadari-africa-staging-bucket"
key    = "env/staging/terraform.tfstate"
region = "us-east-1"
