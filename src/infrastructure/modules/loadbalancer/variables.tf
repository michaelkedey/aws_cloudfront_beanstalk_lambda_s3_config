#names
variable "vpc_names" {
  default = {
    lb     = "bid-lb",
    lb-tg1 = "bid-lb-tg-http",
    lb-tg2 = "bid-lb-tg-https",
    lb_sg  = "bid-lb-sg"

  }

  type        = map(string)
  description = "vpc names"
}

#https in
variable "ingress1" {
  default = {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

  }
}

#http in
variable "ingress2" {
  default = {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

  }
}

#http out
variable "egress2" {
  default = {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
}

#https out
variable "egress1" {
  default = {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

}

variable "default_route" {
  default   = ["0.0.0.0/0"]
  type      = list(string)
  sensitive = true
}

variable "tags_all" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  sensitive   = true
  default = {
    "Environment" = "production",
    "Owners"      = "bid_project"
  }
}

variable "load_balancer_type" {
  default = "application"
  type    = string
}

variable "tg-port0" {
  default = 443
  type    = number
}

variable "tg-port1" {
  default = 80
  type    = number
}

variable "protocols0" {
  default = "HTTPS"
}

variable "protocols1" {
  default = "HTTP"
}

variable "protocols2" {
  default = "tcp"
}

variable "lb_default_action" {
  default   = "forward"
  type      = string
  sensitive = true
}

# #placeholder
# variable "instance_ids" {

# }

variable "subnet_for_lbs" {

}

variable "vpc_id" {

}

variable "lb_egress_cidrs" {

}

variable "idle_timeout" {

}

variable "health_check" {
  default = {
    interval            = 30,
    path                = "/health",
    port                = 80,
    protocol            = "HTTP",
    healthy_threshold   = 2,
    unhealthy_threshold = 4,
    timeout             = 5,
    matcher             = "200-399"
  }
}


