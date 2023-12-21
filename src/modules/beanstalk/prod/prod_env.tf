resource "aws_elastic_beanstalk_application" "bid_app" {
  name        = var.name
  description = var.app_desc

}

resource "aws_elastic_beanstalk_environment" "prod" {
  name                = var.env_name
  application         = aws_elastic_beanstalk_application.bid_app.name
  solution_stack_name = var.stack["windows"]
  tier                = var.tier

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = var.settings_name["iam_profile"]
    value     = aws_iam_role.beanstalk_s3_role.name
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = var.settings_name["vpc"]
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = var.settings_name["sn"]
    value     = join(",", var.subnet_ids) 
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = var.settings_name["i_type"]
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = var.settings_name["asg_min"]
    value     = var.min_instances
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = var.settings_name["asg_max"]
    value     = var.max_instances
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = var.settings_name["system"]
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = var.settings_name["lb_type"]
    value     = "external"
  }

  # You can use this resource to associate the environment with an existing ELB

}

# resource "aws_elastic_beanstalk_environment_resource" "prod_elb" {
#   environment_id = aws_elastic_beanstalk_environment
#   type           = "AWS::ElasticBeanstalk::Environment"
#   name           = var.settings_name["lb_name"]
#   properties = {
#     LoadBalancerName = var.lb_name
#   }
# }


#iam policy
resource "aws_iam_policy" "beanstalk_policy" {
  name   = var.beanstalk_policy_name
  policy = file("${path.module}/beanstalkpolicy.json")
}

#iam role
resource "aws_iam_role" "beanstalk_s3_role" {
  name               = var.beanstalk_role
  assume_role_policy = aws_iam_policy.beanstalk_policy.policy_id
}

#iam policy attachememnt
resource "aws_iam_role_policy_attachment" "beanstalk_s3_policy_attachment" {
  policy_arn = aws_iam_policy.beanstalk_policy.arn
  role       = aws_iam_role.beanstalk_s3_role.name
}


