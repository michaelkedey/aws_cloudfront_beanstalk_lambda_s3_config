terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
  }

  backend "s3" {}
}

# provider "aws" {
#   region = "us-east-1"
#   alias  = "project_region"
# }

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "5.17.0"
#     }
#   }

#   backend "s3" {}
# }
