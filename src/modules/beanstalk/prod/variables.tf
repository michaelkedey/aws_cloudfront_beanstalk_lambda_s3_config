variable "beanstalk_policy_name" {
  default = "beanstalk_policy"
  type    = string
}

variable "beanstalk_role" {
  default = "beanstalk_s3 role"
  type    = string
}

variable "settings_name" {
  default = {
    vpc         = "VPCId",
    sn          = "Subnets",
    iam_profile = "IamInstanceProfile",
    instance    = "InstanceType",
    asg_min     = "MinSize",
    asg_max     = "MaxSize",
    i_type      = "InstanceType"
  }
}

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
variable "vpc_id" {
  description = "The VPC where Beanstalk should be launched."
  type        = string
}

variable "subnet_ids" {
  description = "list of subnets where Beanstalk should be launched."

}

variable "instance_type" {
  description = "type of EC2 instances to launch in Beanstalk."
  type        = string
}

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
}

variable "custom_domain" {
  description = "Custom domain for the Elastic Beanstalk environment."
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS."
}

variable "notification_email" {
  description = "Email address for environment event notifications."
}



