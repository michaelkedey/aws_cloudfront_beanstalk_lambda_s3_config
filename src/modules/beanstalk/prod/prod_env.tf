resource "aws_elastic_beanstalk_application" "bid_app" {
  name = var.app_name
}

# resource "aws_elastic_beanstalk_application_version" "bid_app_version" {
#   bucket      = var.bucket_name
#   name        = var.app_name
#   application = aws_elastic_beanstalk_application.bid_app.id
#   key         = var.app_key

# }


resource "aws_elastic_beanstalk_environment" "prod" {
  application         = aws_elastic_beanstalk_application.bid_app.name
  name                = var.app_name
  solution_stack_name = var.stack["linux"] # Adjust as needed
  tier                = var.tier

  # Reference existing S3 version
  #version_label = var.app_key

  # Network configuration
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.subnet_ids
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = var.lb_type
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerName"
    value     = var.lb_name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.sgs
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = var.asg_trigger # Or other metric
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = var.asg_trigger_min # Adjust as needed
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = var.asg_trigger_max
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.min_instances
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.max_instances
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "LAMBDA_FUNCTION_NAME"
    value     = var.lambda_function_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_REGION"
    value     = var.aws_region
  }

}

resource "aws_iam_role" "beanstalk_s3_role" {
  name = var.beanstalk_s3

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beanstalk_s3_access" {
  role       = aws_iam_role.beanstalk_s3_role.name
  policy_arn = var.beanstalk_s3_access
}

# resource "aws_elastic_beanstalk_environment_variable" "app_settings" {
#   environment_name = aws_elastic_beanstalk_environment.app.name
#   namespace        = "application"
#   name             = "LAMBDA_FUNCTION_NAME"
#   value            = var.lambda_function_name
# }

# resource "aws_elastic_beanstalk_environment_variable" "app_settings2" {
#   environment_name = aws_elastic_beanstalk_environment.app.name
#   namespace        = "application"
#   name             = "AWS_REGION"
#   value            = var.aws_region

# }




















# resource "aws_elastic_beanstalk_environment" "prod" {
#   name                = var.env_name
#   application         = aws_elastic_beanstalk_application.bid_app.name
#   solution_stack_name = var.stack["linux"]
#   tier                = var.tier

#   setting {
#     namespace = "aws:autoscaling:asg"
#     name      = var.settings_name["iam_profile"]
#     value     = aws_iam_role.beanstalk_s3_role.name
#   }

#   setting {
#     namespace = "aws:ec2:vpc"
#     name      = var.settings_name["vpc"]
#     value     = var.vpc_id
#   }

#   setting {
#     namespace = "aws:ec2:vpc"
#     name      = var.settings_name["sn"]
#     value     = join(",", var.subnet_ids) 
#   }

#   setting {
#     namespace = "aws:autoscaling:asg"
#     name      = var.settings_name["i_type"]
#     value     = var.instance_type
#   }

#   setting {
#     namespace = "aws:autoscaling:asg"
#     name      = var.settings_name["asg_min"]
#     value     = var.min_instances
#   }

#   setting {
#     namespace = "aws:autoscaling:asg"
#     name      = var.settings_name["asg_max"]
#     value     = var.max_instances
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:healthreporting:system"
#     name      = var.settings_name["system"]
#     value     = "enhanced"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = var.settings_name["lb_type"]
#     value     = "external"
#   }

#   # You can use this resource to associate the environment with an existing ELB

# }

# # resource "aws_elastic_beanstalk_environment_resource" "prod_elb" {
# #   environment_id = aws_elastic_beanstalk_environment
# #   type           = "AWS::ElasticBeanstalk::Environment"
# #   name           = var.settings_name["lb_name"]
# #   properties = {
# #     LoadBalancerName = var.lb_name
# #   }
# # }


# #iam policy
# # resource "aws_iam_policy" "beanstalk_policy" {
# #   name   = var.beanstalk_policy_name
# #   policy = file("${path.module}/beanstalkpolicy.json")
# # }

# # #iam role
# # resource "aws_iam_role" "beanstalk_s3_role" {
# #   name               = var.beanstalk_role
# #   assume_role_policy = aws_iam_policy.beanstalk_policy.policy_id
# # }

# #from chatgpt
# resource "aws_iam_role" "beanstalk_s3_role" {
#   name               = var.beanstalk_role
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "elasticbeanstalk.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }


# #iam policy attachememnt
# # resource "aws_iam_role_policy_attachment" "beanstalk_s3_policy_attachment" {
# #   policy_arn = aws_iam_policy.beanstalk_policy.arn
# #   role       = aws_iam_role.beanstalk_s3_role.name
# # }


