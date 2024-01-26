output "environment_id" {
  value = aws_elastic_beanstalk_environment.prod.id
}

output "environment_name" {
  value = aws_elastic_beanstalk_environment.prod.name
}

output "instance_ids" {
  value = aws_elastic_beanstalk_environment.prod.instances
}

output "c_name" {
  value = aws_elastic_beanstalk_environment.prod.cname
}

# output "target_group_arn" {
#   value = aws_elastic_beanstalk_environment.prod.load_balancers[0].target_group_arn
# }
