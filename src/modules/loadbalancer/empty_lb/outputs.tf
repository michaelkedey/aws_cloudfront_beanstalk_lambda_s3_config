output "empty_lb_name" {
  value = aws_lb.emptylb.arn
}

output "empty_lb_sg_id" {
  value = aws_security_group.empty_lb_sg.id
}