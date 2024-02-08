#VPC 
resource "aws_vpc" "bid_vpc" {
  cidr_block           = var.cidrs["vpc"]
  provider             = aws.bid_region
  enable_dns_hostnames = true
  enable_dns_support   = true
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
  availability_zone = var.azs[0]
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
  availability_zone = var.azs[1]
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
resource "aws_route_table_association" "public_association1" {
  subnet_id      = aws_subnet.sn_public1.id
  route_table_id = aws_route_table.bid_public_rt.id
}

#associate public rt with public subnet2
resource "aws_route_table_association" "public_association2" {
  subnet_id      = aws_subnet.sn_public2.id
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

# data "aws_ip_ranges" "elasticbeanstalk" {
#   regions  = ["us-east-1"]
#   services = ["elasticbeanstalk"]
# }


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


#sg for lambda instances
resource "aws_security_group" "beanstalk_sg" {
  name        = var.vpc_names["beanstalk_sg"]
  description = "Sg for Beanstalk"
  vpc_id      = aws_vpc.bid_vpc.id

  ingress {
    from_port   = var.ingress1["from_port"]
    to_port     = var.ingress1["to_port"]
    protocol    = var.ingress1["protocol"]
    cidr_blocks = var.def_egress_cidr #[ aws_subnet.sn_private1.cidr_block, aws_subnet.sn_private2.cidr_block ] #security_groups = var.lb_sg
  }

  ingress {
    from_port   = var.ingress2["from_port"]
    to_port     = var.ingress2["to_port"]
    protocol    = var.ingress2["protocol"]
    cidr_blocks = var.def_egress_cidr #[ aws_subnet.sn_private1.cidr_block, aws_subnet.sn_private2.cidr_block ] #var.def_egress_cidr #security_groups = var.lb_sg
  }

  ingress {
    from_port   = var.ingress3["from_port"]
    to_port     = var.ingress3["to_port"]
    protocol    = var.ingress3["protocol"]
    cidr_blocks = var.def_egress_cidr #[ aws_subnet.sn_private1.cidr_block, aws_subnet.sn_private2.cidr_block ] 
  }

  egress {
    from_port   = var.egress3["from_port"]
    to_port     = var.egress3["to_port"]
    protocol    = var.egress3["protocol"]
    cidr_blocks = var.def_egress_cidr
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

  egress {
    from_port   = var.egress1["from_port"]
    to_port     = var.egress1["to_port"]
    protocol    = var.egress1["protocol"]
    cidr_blocks = var.def_egress_cidr
  }

  tags = merge(
    var.tags_all,
    {
      Name = var.vpc_names["beanstalk_sg"]
    }
  )

}


