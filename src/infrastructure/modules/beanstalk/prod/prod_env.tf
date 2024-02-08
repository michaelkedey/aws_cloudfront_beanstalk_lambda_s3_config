# IAM Role for EC2 Instances
resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "beanstalk_ec2_role-2"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}

#iam role for beanstalk service role
resource "aws_iam_role" "beanstalk_service_role" {
  name = "beanstalk-service-role-2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com",
        },
      },
    ],
  })
}


# IAM Policy for EC2 Instances
resource "aws_iam_policy" "beanstalk_ec2_policy" {
  name   = "beanstalk_ec2_policy-2"
  policy = file("${path.module}/beanstalk-ec2-policy.json")
}

#iam policy for beanstalk service role
resource "aws_iam_policy" "beanstalk-service-policy" {
  name   = "beanstalk_service_policy-2"
  policy = file("${path.module}/beanstalk-service-policy.json")
}

#attache policies to roles
resource "aws_iam_role_policy_attachment" "beanstalk_ec2_policy_attachment" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = aws_iam_policy.beanstalk_ec2_policy.arn
  #policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_policy_attachment-2" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkCustomPlatformforEC2Role"
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_policy_attachment-3" {
  role = aws_iam_role.beanstalk_ec2_role.name
  #policy_arn = aws_iam_policy.beanstalk_ec2_policy.arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "beanstalk_service_policy_attachement" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = aws_iam_policy.beanstalk-service-policy.arn
}

resource "aws_iam_role_policy_attachment" "beanstalk_service_policy_attachement_2" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
}

resource "aws_iam_role_policy_attachment" "beanstalk_service_policy_attachement_3" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}


# Instance Profile for EC2 Instances
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile_namesss"
  role = aws_iam_role.beanstalk_ec2_role.name
}


# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "prod" {
  name                = var.beanstalk_name
  application         = var.application_name
  solution_stack_name = var.stack["linux"]
  tier                = var.tier

  # Existing VPC, subnets
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
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = var.elb_subnet_ids
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = false
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service_role.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = var.lb_type
  }


  #autoscaling
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = true
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
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
  }

  #let beanstalk creates its thing.
  # setting {
  #   namespace = "aws:autoscaling:launchconfiguration"
  #   name      = "SecurityGroups"
  #   value     = var.sgs # Replace with your security group ID(s)
  # }


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
  #   name      = "RootVolumeIOPS"
  #   value     = var.root_volume_iops
  # }

  # setting {
  #   namespace = "aws:autoscaling:launchconfiguration"
  #   name      = "RootVolumeThroughput"
  #   value     = var.root_volume_throughput
  # }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
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

  #updates
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = true
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "UpdateLevel"
    value     = "minor"
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime"
    value     = "Tue:09:00"
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ServiceRoleForManagedUpdates"
    value     = "AWSServiceRoleForElasticBeanstalkManagedUpdates"
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "InstanceRefreshEnabled"
    value     = true
  }

  setting {
    namespace = "aws:elasticbeanstalk:trafficsplitting"
    name      = "NewVersionPercent"
    value     = 50
  }

  setting {
    namespace = "aws:elasticbeanstalk:trafficsplitting"
    name      = "EvaluationTime"
    value     = 4
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "TrafficSplitting"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "Timeout"
    value     = 2000
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "IgnoreHealthCheck"
    value     = true
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = var.max_batch_size
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = var.min_instance_in_service
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = true
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "LaunchTemplateTagPropagationEnabled"
    value     = true
  }

  
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "/"
  }

  lifecycle {
    create_before_destroy = true
  }

  #load_balancer

  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "DefaultProcess"
    value     = "default"
  }

  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = true
  }

  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "Protocol"
    value     = "HTTP"
  }


  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "DefaultProcess"
    value     = "default"
  }


  setting {
    namespace = "aws:elbv2:listener:5000"
    name      = "DefaultProcess"
    value     = "default"
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "ListenerEnabled"
    value     = true
  }

  setting {
    namespace = "aws:elbv2:listener:5000"
    name      = "ListenerEnabled"
    value     = true
  }

  setting {
    namespace = "aws:elbv2:listener:5000"
    name      = "Protocol"
    value     = "HTTP"
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "Protocol"
    value     = "HTTP"
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "AccessLogsS3Bucket"
    value     = var.s3_logs_bucket_name
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "IdleTimeout"
    value     = 180
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "AccessLogsS3Enabled"
    value     = true
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "AccessLogsS3Prefix"
    value     = "bid_env-"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "HealthCheckSuccessThreshold"
    value     = "ok"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "EnhancedHealthAuthEnabled"
    value     = true
  }

  #for windows platfotm
  # setting {
  #   namespace = "aws:elasticbeanstalk:container:dotnet:apppool"
  #   name      = "Target Runtime"
  #   value     = "4.0"
  # }

  # setting {
  #   namespace = "aws:elasticbeanstalk:container:dotnet:apppool"
  #   name      = "Enable 32-bit Applications"
  #   value     = "False"
  # }


  #cloudwatch
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = true
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = false
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = 90
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     = true
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "DeleteOnTerminate"
    value     = false
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "RetentionInDays"
    value     = 90
  }



  #env variables
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
    value     = "200,404,301,302,202,400,499"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "DeregistrationDelay"
    value     = 60
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckInterval"
    value     = 200
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckTimeout"
    value     = 30
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthyThresholdCount"
    value     = 2
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = 80
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Protocol"
    value     = "HTTP"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "UnhealthyThresholdCount"
    value     = 7
  }

  #Reference existing S3 version
  #version_label = var.app_version_name

}
