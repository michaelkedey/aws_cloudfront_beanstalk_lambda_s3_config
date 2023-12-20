#VPC 
resource "aws_vpc" "bid_vpc" {
  cidr_block = var.cidrs["vpc"]
  provider   = aws.bid_region
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["vpc"]
    }
  )
}

#private subnets
resource "aws_subnet" "sn_private1" {
  vpc_id            = aws_vpc.bid_vpc.id
  cidr_block        = var.cidrs["sn_private1"]
  provider          = aws.bid_region
  availability_zone = var.azs[0]
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["sn_private1"]
    }
  )
}

resource "aws_subnet" "sn_private2" {
  vpc_id            = aws_vpc.bid_vpc.id
  cidr_block        = var.cidrs["sn_private2"]
  provider          = aws.bid_region
  availability_zone = var.azs[1]
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["sn_private2"]
    }
  )
}

#public subnets
resource "aws_subnet" "sn_public1" {
  vpc_id            = aws_vpc.bid_vpc.id
  cidr_block        = var.cidrs["sn_public1"]
  provider          = aws.bid_region
  availability_zone = var.azs[2]
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["sn_public1"]
    }
  )
}

resource "aws_subnet" "sn_public2" {
  vpc_id            = aws_vpc.bid_vpc.id
  cidr_block        = var.cidrs["sn_public2"]
  provider          = aws.bid_region
  availability_zone = var.azs[3]
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["sn_public2"]
    }
  )
}

#Internet_gateway
resource "aws_internet_gateway" "bid_gw" {
  vpc_id = aws_vpc.bid_vpc.id
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["igw"]
    }
  )
}

#public_rt
resource "aws_route_table" "bid_public_rt" {
  vpc_id = aws_vpc.bid_vpc.id
  route {
    cidr_block = var.def_rt_cidr
    gateway_id = aws_internet_gateway.bid_gw.id
  }
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["public_rt"]
    }
  )
}

#associate public rt with public subnet1
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.sn_public1.id
  route_table_id = aws_route_table.bid_public_rt.id
}

#eip needed to work with the nat gateway
resource "aws_eip" "bid_eip" {
  #instance = var.instance_id
}

#nat gateway
resource "aws_nat_gateway" "bid_ngw" {
  allocation_id = aws_eip.bid_eip.id
  subnet_id     = aws_subnet.sn_public1.id
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["ngw"]
    }
  )
  depends_on = [aws_internet_gateway.bid_gw]
}

#private route table
resource "aws_route_table" "bid_private_rt" {
  vpc_id = aws_vpc.bid_vpc.id
  route {
    cidr_block     = var.cidrs["default_route"]
    nat_gateway_id = aws_nat_gateway.bid_ngw.id
  }
  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["private_rt"]
    }
  )
}

#associate private rt with private sn1
resource "aws_route_table_association" "private_association1" {
  subnet_id      = aws_subnet.sn_private1.id
  route_table_id = aws_route_table.bid_private_rt.id
}

#associate private rt with private sn2
resource "aws_route_table_association" "private_association2" {
  subnet_id      = aws_subnet.sn_private2.id
  route_table_id = aws_route_table.bid_private_rt.id
}

#sg for beanstalk instances
resource "aws_security_group" "beanstalk_sg" {
  name        = var.vpc_names["beanstalk_sg"]
  description = "Sg for Beanstalk"
  vpc_id      = aws_vpc.bid_vpc.id

  ingress {
    from_port       = var.ingress1["from_port"]
    to_port         = var.ingress1["to_port"]
    protocol        = var.ingress1["protocol"]
    security_groups = [aws_security_group.bid_lb_sg.id]
  }

  ingress {
    from_port       = var.ingress2["from_port"]
    to_port         = var.ingress2["to_port"]
    protocol        = var.ingress2["protocol"]
    security_groups = [aws_security_group.bid_lb_sg.id]
  }

  egress {
    from_port   = var.egress1["from_port"]
    to_port     = var.egress1["to_port"]
    protocol    = var.egress1["protocol"]
    cidr_blocks = var.def_egress_cidr
  }

  egress {
    from_port   = var.egress2["from_port"]
    to_port     = var.egress2["to_port"]
    protocol    = var.egress2["protocol"]
    cidr_blocks = var.def_egress_cidr
  }

  tags = var.tags_all

}

#load balancer
resource "aws_lb" "bid_lb" {
  name               = var.vpc_names["lb"]
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.bid_lb_sg.id]
  subnets            = [aws_subnet.sn_public1.id, aws_subnet.sn_public2.id]
  enable_http2       = true
  #idle_timeout          = 60
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
  port              = var.ports[1]
  protocol          = var.protocols[1]

  default_action {
    type             = var.lb_default_action
    target_group_arn = aws_lb_target_group.bid_lb_tg1.arn
  }
  tags = var.tags_all
}

#load balancer traffic listener https
resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.bid_lb.arn
  port              = var.ports[0]
  protocol          = var.protocols[0]

  default_action {
    type             = var.lb_default_action
    target_group_arn = aws_lb_target_group.bid_lb_tg2.arn
  }
  tags = var.tags_all
}

#target group for load balancer - http
resource "aws_lb_target_group" "bid_lb_tg1" {
  name     = var.vpc_names["lb_tg1"]
  port     = var.ports[1]
  protocol = var.protocols[1]
  vpc_id   = aws_vpc.bid_vpc.id

  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["lb_tg1"]
    }
  )
}

#target group for load balancer - https
resource "aws_lb_target_group" "bid_lb_tg2" {
  name     = var.vpc_names["lb_tg2"]
  port     = var.ports[0]
  protocol = var.protocols[0]
  vpc_id   = aws_vpc.bid_vpc.id

  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["lb_tg2"]
    }
  )
}

#associate the instance with the target group - http
resource "aws_lb_target_group_attachment" "bid_tg_attachment1" {
  for_each         = toset(var.instance_ids)
  target_group_arn = aws_lb_target_group.bid_lb_tg1.arn
  target_id        = each.value
  port             = var.ports[1]
}

#associate the instance with the target group - https
resource "aws_lb_target_group_attachment" "bid_tg_attachment2" {
  for_each         = toset(var.instance_ids)
  target_group_arn = aws_lb_target_group.bid_lb_tg2.arn
  target_id        = each.value
  port             = var.ports[0]
}

#security group for load balancer
#necessary in order to set the id for the ingress web traffic in the instance sg
resource "aws_security_group" "bid_lb_sg" {
  ingress {
    from_port   = var.ingress1["from_port"]
    to_port     = var.ingress1["to_port"]
    protocol    = var.protocols[2]
    cidr_blocks = var.default_route
  }

  ingress {
    from_port   = var.ingress2["from_port"]
    to_port     = var.ingress2["to_port"]
    protocol    = var.protocols[2]
    cidr_blocks = var.default_route
  }

  egress {
    from_port   = var.egress1["from_port"]
    to_port     = var.egress1["to_port"]
    protocol    = var.protocols[2]
    cidr_blocks = var.default_route
  }

  ingress {
    from_port   = var.egress2["from_port"]
    to_port     = var.egress2["to_port"]
    protocol    = var.protocols[2]
    cidr_blocks = var.default_route
  }

  name   = var.vpc_names["lb_sg"]
  vpc_id = aws_vpc.bid_vpc.id

  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["lb_sg"]
    }
  )
}
