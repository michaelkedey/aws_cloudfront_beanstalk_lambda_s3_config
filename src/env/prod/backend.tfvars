
# terraform {
#     backend "s3" {
#     #bucket exists already prod
#     bucket = "hadariafricaprod-bucket"
#     key    = "prod/terraform.tfstate"
#     region = "us-east-1"

#   }
# }

bucket = "hadariafricaprod-bucket"
key    = "env/prod/terraform.tfstate"
region = "us-east-1"