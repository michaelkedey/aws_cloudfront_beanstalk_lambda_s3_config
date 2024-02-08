#load balancer
resource "aws_lb" "bid_lb" {
  name                             = var.vpc_names["lb"]
  internal                         = false
  load_balancer_type               = var.load_balancer_type
  security_groups                  = [aws_security_group.bid_lb_sg.id]
  subnets                          = var.subnet_for_lbs
  enable_http2                     = true
  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = true
  #enable_deletion_protection = true
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["lb"]
    }
  )
}

#load balancer traffic listener http
resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn = aws_lb.bid_lb.arn
  port              = var.tg-port1
  protocol          = var.protocols1

  default_action {
    type             = var.lb_default_action
    target_group_arn = aws_lb_target_group.bid_lb-tg1.arn
  }
  tags = var.tags_all
}

#load balancer traffic listener https
resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.bid_lb.arn
  port              = var.tg-port0
  protocol          = var.protocols0

  default_action {
    type             = var.lb_default_action
    target_group_arn = aws_lb_target_group.bid-lb-tg2.arn
  }
  tags = var.tags_all
}

#target group for load balancer - http
resource "aws_lb_target_group" "bid_lb-tg1" {
  name     = var.vpc_names["lb-tg1"]
  port     = var.tg-port1
  protocol = var.protocols1
  vpc_id   = var.vpc_id

  health_check {
    interval            = var.health_check["interval"]
    path                = var.health_check["path"]
    port                = var.health_check["port"]
    protocol            = var.health_check["protocol"]
    healthy_threshold   = var.health_check["healthy_threshold"]
    unhealthy_threshold = var.health_check["unhealthy_threshold"]
    timeout             = var.health_check["timeout"]
    matcher             = var.health_check["matcher"]
  }
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["lb-tg1"]
    }
  )
}

#target group for load balancer - https
resource "aws_lb_target_group" "bid-lb-tg2" {
  name     = var.vpc_names["lb-tg2"]
  port     = var.tg-port0
  protocol = var.protocols0
  vpc_id   = var.vpc_id

  health_check {
    interval            = var.health_check["interval"]
    path                = var.health_check["path"]
    port                = var.health_check["port"]
    protocol            = var.health_check["protocol"]
    healthy_threshold   = var.health_check["healthy_threshold"]
    unhealthy_threshold = var.health_check["unhealthy_threshold"]
    timeout             = var.health_check["timeout"]
    matcher             = var.health_check["matcher"]
  }
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["lb-tg2"]
    }
  )
}


#associate the instances with the target group - http
# resource "aws_lb_target_group_attachment" "bid_tg_attachment1" {
#   for_each         = var.instance_ids
#   target_group_arn = aws_lb_target_group.bid_lb-tg1.arn
#   target_id        = each.value
#   port             = var.tg-port1
# }

#associate the instance with the target group - https
# resource "aws_lb_target_group_attachment" "bid_tg_attachment2" {
#   for_each         = var.instance_ids
#   target_group_arn = aws_lb_target_group.bid-lb-tg2.arn
#   target_id        = each.value
#   port             = var.tg-port0
# }

#security group for load balancer
#necessary in order to set the id for the ingress web traffic in the instance sg
resource "aws_security_group" "bid_lb_sg" {

  ingress {
    from_port   = var.ingress1["from_port"]
    to_port     = var.ingress1["to_port"]
    protocol    = var.protocols2
    cidr_blocks = var.default_route
  }

  ingress {
    from_port   = var.ingress2["from_port"]
    to_port     = var.ingress2["to_port"]
    protocol    = var.protocols2
    cidr_blocks = var.default_route
  }

  egress {
    from_port   = var.egress1["from_port"]
    to_port     = var.egress1["to_port"]
    protocol    = var.protocols2
    cidr_blocks = var.lb_egress_cidrs
  }

  egress {
    from_port   = var.egress2["from_port"]
    to_port     = var.egress2["to_port"]
    protocol    = var.protocols2
    cidr_blocks = var.lb_egress_cidrs
  }

  name   = var.vpc_names["lb_sg"]
  vpc_id = var.vpc_id

  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["lb_sg"]
    }
  )
}
