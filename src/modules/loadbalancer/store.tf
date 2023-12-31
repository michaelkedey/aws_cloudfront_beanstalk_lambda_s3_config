resource "aws_ssm_parameter" "lb_sg_id" {
  name  = "/bid/lb_sg"
  type  = "String"
  value = aws_security_group.bid_lb_sg.id

}

resource "aws_ssm_parameter" "lb_name" {
  name  = "/bid/lb_name"
  type  = "String"
  value = aws_security_group.bid_lb_sg.name

}

resource "aws_ssm_parameter" "lb_arn" {
  name  = "/bid/lb_name"
  type  = "String"
  value = aws_security_group.bid_lb_sg.arn

}

