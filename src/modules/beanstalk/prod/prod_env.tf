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

#iam role for beanstalk service role
resource "aws_iam_role" "beanstalk_service_role" {
  name = "beanstalk-service-role"

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
  name = "beanstalk_ec2_policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "BucketAccess",
          "Action" : [
            "s3:Get*",
            "s3:List*",
            "s3:PutObject"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::elasticbeanstalk-*",
            "arn:aws:s3:::elasticbeanstalk-*/*"
          ]
        },
        {
          "Sid" : "XRayAccess",
          "Action" : [
            "xray:PutTraceSegments",
            "xray:PutTelemetryRecords",
            "xray:GetSamplingRules",
            "xray:GetSamplingTargets",
            "xray:GetSamplingStatisticSummaries"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Sid" : "CloudWatchLogsAccess",
          "Action" : [
            "logs:PutLogEvents",
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:DescribeLogGroups"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
          ]
        },
        {
          "Sid" : "ElasticBeanstalkHealthAccess",
          "Action" : [
            "elasticbeanstalk:PutInstanceStatistics"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:elasticbeanstalk:*:*:application/*",
            "arn:aws:elasticbeanstalk:*:*:environment/*"
          ]
        }
      ]
    }
  )
}

#iam policy for beanstalk service role
resource "aws_iam_policy" "beanstalk-service-policy" {
  name = "beanstalk_service_policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "elasticloadbalancing:DescribeInstanceHealth",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeTargetHealth",
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceStatus",
            "ec2:GetConsoleOutput",
            "ec2:AssociateAddress",
            "ec2:DescribeAddresses",
            "ec2:DescribeSecurityGroups",
            "sqs:GetQueueAttributes",
            "sqs:GetQueueUrl",
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeScalingActivities",
            "autoscaling:DescribeNotificationConfigurations",
            "sns:Publish"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "ElasticBeanstalkPermissions",
          "Effect" : "Allow",
          "Action" : [
            "elasticbeanstalk:*"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "AllowPassRoleToElasticBeanstalkAndDownstreamServices",
          "Effect" : "Allow",
          "Action" : "iam:PassRole",
          "Resource" : "arn:aws:iam::*:role/*",
          "Condition" : {
            "StringEquals" : {
              "iam:PassedToService" : [
                "elasticbeanstalk.amazonaws.com",
                "ec2.amazonaws.com",
                "ec2.amazonaws.com.cn",
                "autoscaling.amazonaws.com",
                "elasticloadbalancing.amazonaws.com",
                "ecs.amazonaws.com",
                "cloudformation.amazonaws.com"
              ]
            }
          }
        },
        {
          "Sid" : "ReadOnlyPermissions",
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:DescribeAccountLimits",
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeLoadBalancers",
            "autoscaling:DescribeNotificationConfigurations",
            "autoscaling:DescribeScalingActivities",
            "autoscaling:DescribeScheduledActions",
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeAddresses",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeImages",
            "ec2:DescribeInstanceAttribute",
            "ec2:DescribeInstances",
            "ec2:DescribeKeyPairs",
            "ec2:DescribeLaunchTemplates",
            "ec2:DescribeLaunchTemplateVersions",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSnapshots",
            "ec2:DescribeSpotInstanceRequests",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcClassicLink",
            "ec2:DescribeVpcs",
            "elasticloadbalancing:DescribeInstanceHealth",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeTargetHealth",
            "logs:DescribeLogGroups",
            "rds:DescribeDBEngineVersions",
            "rds:DescribeDBInstances",
            "rds:DescribeOrderableDBInstanceOptions",
            "sns:ListSubscriptionsByTopic"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "EC2BroadOperationPermissions",
          "Effect" : "Allow",
          "Action" : [
            "ec2:AllocateAddress",
            "ec2:AssociateAddress",
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CreateLaunchTemplate",
            "ec2:CreateLaunchTemplateVersion",
            "ec2:CreateSecurityGroup",
            "ec2:DeleteLaunchTemplate",
            "ec2:DeleteLaunchTemplateVersions",
            "ec2:DeleteSecurityGroup",
            "ec2:DisassociateAddress",
            "ec2:ReleaseAddress",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RevokeSecurityGroupIngress"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "EC2RunInstancesOperationPermissions",
          "Effect" : "Allow",
          "Action" : "ec2:RunInstances",
          "Resource" : "*",
          "Condition" : {
            "ArnLike" : {
              "ec2:LaunchTemplate" : "arn:aws:ec2:*:*:launch-template/*"
            }
          }
        },
        {
          "Sid" : "EC2TerminateInstancesOperationPermissions",
          "Effect" : "Allow",
          "Action" : [
            "ec2:TerminateInstances"
          ],
          "Resource" : "arn:aws:ec2:*:*:instance/*",
          "Condition" : {
            "StringLike" : {
              "ec2:ResourceTag/aws:cloudformation:stack-id" : [
                "arn:aws:cloudformation:*:*:stack/awseb-e-*",
                "arn:aws:cloudformation:*:*:stack/eb-*"
              ]
            }
          }
        },
        {
          "Sid" : "ASGOperationPermissions",
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:AttachInstances",
            "autoscaling:CreateAutoScalingGroup",
            "autoscaling:CreateLaunchConfiguration",
            "autoscaling:DeleteLaunchConfiguration",
            "autoscaling:DeleteAutoScalingGroup",
            "autoscaling:DeleteScheduledAction",
            "autoscaling:DetachInstances",
            "autoscaling:DeletePolicy",
            "autoscaling:PutScalingPolicy",
            "autoscaling:PutScheduledUpdateGroupAction",
            "autoscaling:PutNotificationConfiguration",
            "autoscaling:ResumeProcesses",
            "autoscaling:SetDesiredCapacity",
            "autoscaling:SuspendProcesses",
            "autoscaling:TerminateInstanceInAutoScalingGroup",
            "autoscaling:UpdateAutoScalingGroup"
          ],
          "Resource" : [
            "arn:aws:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/awseb-e-*",
            "arn:aws:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/eb-*",
            "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/awseb-e-*",
            "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/eb-*"
          ]
        },
        {
          "Sid" : "ELBOperationPermissions",
          "Effect" : "Allow",
          "Action" : [
            "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
            "elasticloadbalancing:ConfigureHealthCheck",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:RegisterTargets"
          ],
          "Resource" : [
            "arn:aws:elasticloadbalancing:*:*:targetgroup/awseb-*",
            "arn:aws:elasticloadbalancing:*:*:targetgroup/eb-*",
            "arn:aws:elasticloadbalancing:*:*:loadbalancer/awseb-*",
            "arn:aws:elasticloadbalancing:*:*:loadbalancer/eb-*",
            "arn:aws:elasticloadbalancing:*:*:loadbalancer/*/awseb-*/*",
            "arn:aws:elasticloadbalancing:*:*:loadbalancer/*/eb-*/*"
          ]
        },
        {
          "Sid" : "CWLogsOperationPermissions",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:DeleteLogGroup",
            "logs:PutRetentionPolicy"
          ],
          "Resource" : "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk/*"
        },
        {
          "Sid" : "S3ObjectOperationPermissions",
          "Effect" : "Allow",
          "Action" : [
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:GetObjectVersion",
            "s3:GetObjectVersionAcl",
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:PutObjectVersionAcl"
          ],
          "Resource" : "arn:aws:s3:::elasticbeanstalk-*/*"
        },
        {
          "Sid" : "S3BucketOperationPermissions",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetBucketLocation",
            "s3:GetBucketPolicy",
            "s3:ListBucket",
            "s3:PutBucketPolicy"
          ],
          "Resource" : "arn:aws:s3:::elasticbeanstalk-*"
        },
        {
          "Sid" : "CWPutMetricAlarmOperationPermissions",
          "Effect" : "Allow",
          "Action" : [
            "cloudwatch:PutMetricAlarm"
          ],
          "Resource" : [
            "arn:aws:cloudwatch:*:*:alarm:awseb-*",
            "arn:aws:cloudwatch:*:*:alarm:eb-*"
          ]
        }
      ]
    }
  )
}


#attache policies to roles
resource "aws_iam_role_policy_attachment" "beanstalk_ec2_policy_attachment" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = aws_iam_policy.beanstalk_ec2_policy.arn
}

resource "aws_iam_role_policy_attachment" "beanstalk_service_policy_attachement" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = aws_iam_policy.beanstalk-service-policy.arn
}


# Instance Profile for EC2 Instances
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}


# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "prod" {
  name                = var.beanstalk_name
  application         = var.application_name # Replace with your application name
  solution_stack_name = var.stack["linux"]   # Suitable for .NET
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

  # setting {
  #   namespace = "aws:autoscaling:asg"
  #   name      = "LaunchTemplateTagPropagationEnabled"
  #   value     = true
  # }

  ####################################################################################
  # #schedule autoscaling 
  # setting {
  #     namespace = "aws:autoscaling:scheduledaction"
  #     name      = "StartTime"
  #     value     = var.value
  #   }

  #   setting {
  #     namespace = "aws:autoscaling:scheduledaction"
  #     name      = "EndTime"
  #     value     = var.value
  #   }

  #   setting {
  #     namespace = "aws:autoscaling:scheduledaction"
  #     name      = "MaxSize"
  #     value     = var.value
  #   }

  #   setting {
  #     namespace = "aws:autoscaling:scheduledaction"
  #     name      = "MinSize"
  #     value     = var.value
  #   }

  #   setting {
  #     namespace = "aws:autoscaling:scheduledaction"
  #     name      = "DesiredCapacity"
  #     value     = var.value
  #   }

  #   setting {
  #     namespace = "aws:autoscaling:scheduledaction"
  #     name      = "Recurrence"
  #     value     = var.value
  #   }

  #   setting {
  #     namespace = "aws:autoscaling:scheduledaction"
  #     name      = "Suspend"
  #     value     = var.value
  #   }


  #use existing load balancer

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
  #   value     = true
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
    value     = "/"
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
  #   value = true
  # }

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

  # setting {
  #   namespace = "aws:elbv2:listener:default"
  #   name      = "Rules"
  #   value     = <<EOF
  #     [
  #       {
  #         "RuleArn": "${var.app_desc}",
  #         "Priority": 1
  #       },
  #       {
  #         "RuleArn": "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener-rule/app/my-load-balancer/443/my-rule2/fedcba0987654321",
  #         "Priority": 2
  #       }
  #     ]
  #     EOF 

  # }


  # setting {
  #   namespace = "aws:elbv2:listener:default"
  #   name      = "SSLCertificateArns"
  #   value     = "ssl-arn"
  # }

  # setting {
  #   namespace = "aws:elbv2:listener:default"
  #   name      = "SSLPolicy"
  #   value     = "ssl-policy"
  # }



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

  # setting {
  #   namespace = "aws:elbv2:listener:5204"
  #   name      = "DefaultProcess"
  #   value     = "default"
  # }

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

  # setting {
  #   namespace = "aws:elbv2:listener:5204"
  #   name      = "ListenerEnabled"
  #   value     = true
  # }

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
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "InstanceRefreshEnabled"
    value     = true
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

  setting {
    namespace = "aws:elasticbeanstalk:trafficsplitting"
    name      = "NewVersionPercent"
    value     = 50
  }

  setting {
    namespace = "aws:elasticbeanstalk:trafficsplitting"
    name      = "EvaluationTime"
    value     = 7
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

  setting {
    namespace = "aws:elasticbeanstalk:environment:proxy"
    name      = "ProxyServer"
    value     = "nginx"
  }

  # setting {
  #   namespace = "aws:ec2:instances"
  #   name      = "SupportedArchitectures"
  #   value     = "arm64,x86_64"
  # }


  #Reference existing S3 version
  version_label = var.app_version_name


}
