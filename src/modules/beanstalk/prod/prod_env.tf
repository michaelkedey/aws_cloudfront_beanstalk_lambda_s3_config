resource "aws_elastic_beanstalk_environment" "prod" {
  application         = var.application_name
  name                = var.app_name
  solution_stack_name = var.stack["linux"] # Adjust as needed
  tier                = var.tier

  # Reference existing S3 version
  #version_label = var.app_key

  # Network configuration
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_role.beanstalk_ec2_role.id #"aws-elasticbeanstalk-ec2-role"
  }

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

  # setting {
  #   namespace = "aws:elasticbeanstalk:environment"
  #   name      = "LoadBalancerType"
  #   value     = var.lb_type
  # }

  # setting {
  #   namespace = "aws:elb:loadbalancer"
  #   name      = "LoadBalancerName"
  #   value     = var.lb_name
  # }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.sgs
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
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
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = var.root_volume_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = var.root_volume_size
  }

  # setting {
  #   namespace = "aws:autoscaling:launchconfiguration"
  #   name      = "SecurityGroups"
  #   value     = join("", aws_security_group.default.*.id)
  # }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "InstanceRefreshEnabled"
    value     = "true"
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

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  # setting {
  #   namespace = "aws:elasticbeanstalk:environment"
  #   name      = "LoadBalancerType"
  #   value     = "application"
  # }

  # setting {
  #   namespace = "aws:ec2:vpc"
  #   name      = "ELBScheme"
  #   value     = "internet facing"
  # }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "LoadBalancerArn"
    value     = var.lb_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "beanstalk_ec2_role" {
  name               = "beanstalk_role_2"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

}


data "aws_iam_policy" "beanstalk_policy" {
  name = "beanstalk_policy_2"
  #policy = file("${path.module}/beanstalkpolicy.json")
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_role_policy" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = data.aws_iam_policy.beanstalk_policy.arn
}

# resource "aws_iam_policy" "ec2_profile_policy" {
#   name   = "ec2_profile_policy"
#   policy = file("${path.module}/iam_instance_profile.json")
# }


# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "ec2_profile"  
#   role = aws_iam_role.beanstalk_ec2_role.name 
# }


# resource "aws_iam_role_policy_attachment" "ec2" {
#   role       = aws_iam_role.beanstalk_ec2_role.name
#   policy_arn = aws_iam_policy.ec2_profile_policy.arn
# }