output "environment_id" {
  value = aws_elastic_beanstalk_environment.prod.id
}

output "environment_name" {
  value = aws_elastic_beanstalk_environment.prod.name
}

output "instance_ids" {
  value = aws_elastic_beanstalk_environment.prod.instances
}
# output "load_balancer_dns_name" {
#   value = aws_elastic_beanstalk_environment_resource.prod_elb.d
# }
