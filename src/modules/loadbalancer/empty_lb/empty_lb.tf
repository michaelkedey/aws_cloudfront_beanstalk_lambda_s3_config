resource "aws_lb" "emptylb" {
  name               = "emptylb"
  internal           = false
  load_balancer_type = "application"
  #idle_timeout          = 60
  enable_cross_zone_load_balancing = true
  #enable_deletion_protection = true

  subnets = var.subnets
}


resource "aws_security_group" "empty_lb_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_cidr

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}