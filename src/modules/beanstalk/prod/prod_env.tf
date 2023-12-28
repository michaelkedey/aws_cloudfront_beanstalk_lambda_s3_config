# IAM Role for EC2 Instances
resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "beanstalk_ec2_role"

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

# IAM Policy for EC2 Instances
# IAM Policy for EC2 Instances
resource "aws_iam_policy" "beanstalk_ec2_policy" {
  name = "beanstalk_ec2_policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject"
          ],
          "Resource" : [
            "arn:aws:s3:::myoneandonlystaticbucket/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "elasticbeanstalk:UpdateEnvironment",
            "elasticbeanstalk:DescribeEnvironments",
            "elasticbeanstalk:CreateStorageLocation"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceStatus",
            "ec2:RunInstances",
            "ec2:TerminateInstances",
            "ec2:CreateTags",
            "ec2:DescribeKeyPairs",
            "ec2:CreateKeyPair",
            "ec2:DeleteKeyPair",
            "ec2:AssociateIamInstanceProfile",
            "ec2:AttachNetworkInterface",
            "ec2:CreateSecurityGroup",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcs",
            "ec2:DetachNetworkInterface",
            "ec2:RevokeSecurityGroupIngress"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:CreateAutoScalingGroup",
            "autoscaling:UpdateAutoScalingGroup",
            "autoscaling:DeleteAutoScalingGroup",
            "autoscaling:CreateLaunchConfiguration",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DeleteLaunchConfiguration",
            "autoscaling:SetDesiredCapacity",
            "autoscaling:AttachInstances",
            "autoscaling:DetachInstances"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:ConfigureHealthCheck",
            "elasticloadbalancing:CreateLoadBalancerListeners",
            "elasticloadbalancing:DeleteLoadBalancerListeners",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:SetSecurityGroups"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "cloudwatch:PutMetricData",
            "cloudwatch:GetMetricStatistics",
            "cloudwatch:DescribeAlarms",
            "cloudwatch:PutMetricAlarm",
            "cloudwatch:EnableAlarmActions",
            "cloudwatch:DeleteAlarms"
          ],
          "Resource" : "*"
        },
      ]
    }
  )
}


resource "aws_iam_role_policy_attachment" "beanstalk_ec2_policy_attachment" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = aws_iam_policy.beanstalk_ec2_policy.arn
}

# Instance Profile for EC2 Instances
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "prod" {
  name                = "my-beanstalk-env"
  application         = var.app_name       # Replace with your application name
  solution_stack_name = var.stack["linux"] # Suitable for .NET
  tier                = var.tier

  # Existing VPC, subnets, and load balancer
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
    value     = "true"
  }


  #autoscaling
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2_profile.name
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
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.sgs # Replace with your security group ID(s)
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
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = var.lb_type
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

  # #LoadBalancer

  # setting {
  #   namespace = "aws:elasticbeanstalk:environment"
  #   name      = "ServiceRole"
  #   value     = aws_iam_role.beanstalk_ec2_role.name
  # }

  # setting {
  #   namespace = "aws:elasticbeanstalk:environment"
  #   name      = "EnvironmentType"
  #   value     = "LoadBalanced"
  # }

  # setting {
  #   namespace = "aws:elasticbeanstalk:environment"
  #   name      = "LoadBalancerType"
  #   value     = var.lb_type
  # }

  # #lets the env know to expect an existing load balancer
  # setting {
  #   namespace = "aws:elasticbeanstalk:environment"
  #   name      = "LoadBalancerIsShared"
  #   value     = "true"
  # }

  # #specifies to use existing lb
  # setting {
  #   namespace = "aws:elbv2:loadbalancer"
  #   name      = "SharedLoadBalancer"
  #   value     = var.lb_arn
  # }

  # setting {
  #   namespace = "aws:elbv2:loadbalancer"
  #   name      = "SecurityGroups"
  #   value     = var.sgs
  # }

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "/health"
  }

  lifecycle {
    create_before_destroy = true
  }


  #beanstalk managed lb conf
  # setting {
  #   namespace = "aws:elbv2:loadbalancer"
  #   name = "ManagedSecurityGroup"
  #   value = var.sgs
  # }

  # setting {
  #   namespace = "aws:elb:listener"
  #   name = "ListenerEnabled"
  #   value = "true"
  # }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "DefaultProcess"
    value     = "default"
  }

  setting {
    namespace = "aws:elbv2:listener:5204"
    name      = "DefaultProcess"
    value     = "default"
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "ListenerEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elbv2:listener:5204"
    name      = "ListenerEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elbv2:listener:5204"
    name      = "Protocol"
    value     = "HTTP"
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "Protocol"
    value     = "HTTP"
  }


  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "InstanceRefreshEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "AccessLogsS3Bucket"
    value     = var.s3_logs_bucket_id
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "IdleTimeout"
    value     = 60
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "AccessLogsS3Enabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:proxy"
    name      = "ProxyServer"
    value     = "nginx"
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
    value     = "200"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "DeregistrationDelay"
    value     = "60"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckInterval"
    value     = "20"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/health"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckTimeout"
    value     = "7"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthyThresholdCount"
    value     = "2"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = "80"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Protocol"
    value     = "HTTP"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "UnhealthyThresholdCount"
    value     = "7"
  }


  #Reference existing S3 version
  version_label = var.app_key

}