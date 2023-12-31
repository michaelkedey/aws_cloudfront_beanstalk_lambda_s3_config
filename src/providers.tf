terraform {

  backend "s3" {
    #bucket exists already / change to an existing bucket
    bucket = "sedem-terra333-bucket"
    key    = "bid-project/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "bid_region"
}



