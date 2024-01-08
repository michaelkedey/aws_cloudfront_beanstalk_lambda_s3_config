#placeholder
#variable "app_version_name" {}

# variable "lb_name" {}

# variable "sgs" {

# }

variable "s3_logs_bucket_id" {

}

variable "instance_type" {}

variable "lambda_function_name" {}

variable "vpc_id" {

}

variable "aws_region" {
  default = "us-east-1"
}

variable "application_name" {

}

variable "lb_type" {
  default = "application"
}

variable "beanstalk_s3" {
  default = "beanstalk-s3-role"

}

variable "beanstalk_s3_access" {
  default = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

variable "asg_trigger" {
  default = "CPUUtilization"
}

variable "asg_trigger_min" {
  default = 30
}

variable "asg_trigger_max" {
  default = 90
}

# variable "application_name" {

# }

variable "root_volume_type" {

}

variable "root_volume_size" {

}




variable "beanstalk_policy_name" {
  default = "beanstalk_policy"
  type    = string
}

variable "beanstalk_role" {
  default = "beanstalk-s3-role"
  type    = string
}

# variable "settings_name" {
#   default = {
#     vpc         = "VPCId",
#     sn          = "Subnets",
#     iam_profile = "IamInstanceProfile",
#     instance    = "InstanceType",
#     asg_min     = "MinSize",
#     asg_max     = "MaxSize",
#     i_type      = "InstanceType",
#     lb_type     = "LoadBalancerType",
#     system      = "SystemType",
#     lb_name     = "AWSEBLoadBalancer"
#   }
# }

# variable "instance_type" {
#   default = "t2_micro"
#   type = string
# }

# variable "min_instances" {
#   default = 2
#   type = number
# }

# variable "max_instances" {
#   default = 4
#   type = number
# }


#placeholders for customization
# variable "vpc_id" {
#   description = "The VPC where Beanstalk should be launched."
#   type        = string
# }

variable "subnet_ids" {
  description = "list of subnets where Beanstalk should be launched."
  #type = list(string)

}

# variable "instance_type" {
#   description = "type of EC2 instances to launch in Beanstalk."
#   type        = string
# }

variable "min_instances" {
  description = "minimum number of instances in the asg"
  type        = number
}

variable "max_instances" {
  description = "maximum number of instances in the asg"
  type        = number
}

variable "stickiness_enabled" {
  description = "Enable or disable stickiness for the environment."
  type        = bool
  default     = false
}

# variable "custom_domain" {
#   description = "Custom domain for the Elastic Beanstalk environment."
# }

# variable "ssl_certificate_arn" {
#   description = "ARN of the SSL certificate for HTTPS."
# }

# variable "notification_email" {
#   description = "Email address for environment event notifications."
# }

variable "app_desc" {
  type    = string
  default = "bid app"
}

variable "name" {
  default = "dotnet_app"
  type    = string
}


variable "env" {
  default     = ["dev", "prod"]
  type        = list(string)
  description = "environment names"
}

variable "stack" {
  default = {
    # linux   = "64bit Amazon Linux 2 v4.0.0 running ASP.NET Core 6.0",
    linux    = "64bit Amazon Linux 2023 v3.0.2 running .NET 6", #.NET 6 running on 64bit Amazon Linux 2023
    windows  = "64bit Windows Server 2022 v2.14.0 running ASP.NET Core 6.0"
    windows2 = "64bit Windows Server 2019 v2.13.1 running IIS 10.0"
  }

}

variable "tier" {
  default = "WebServer"

}

variable "env_name" {
  default = "bidproject"
}

# variable "lb_arn" {

# }

variable "s3_logs_bucket_name" {

}

#place holders
# variable "bucket" { type = string }
# variable "key" { type = string }

variable "elb_subnet_ids" {

}

# variable "http_target_group" {
#   default = output.target_group_arn 
# }


variable "beanstalk_name" {

}

variable "max_batch_size"{
  default = 50
  type = number
}

variable "min_instance_in_service"{
  default = 2
  type = number
}