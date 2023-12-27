#vpc cidrs
variable "cidrs" {
  default = {
    vpc           = "10.10.0.0/16",
    sn_private1   = "10.10.1.0/24",
    sn_private2   = "10.10.2.0/24",
    sn_public1    = "10.10.3.0/24",
    sn_public2    = "10.10.4.0/24",
    default_route = "0.0.0.0/0"
  }

  sensitive   = true
  type        = map(string)
  description = "cidr blocks for vpc components"
}

#names
variable "vpc_names" {
  default = {
    vpc          = "bid_vpc",
    sn_private1  = "bid_private_sn1",
    sn_private2  = "bid_private_sn2",
    sn_public1   = "bid_public_sn1",
    sn_public2   = "bid_public_sn2",
    igw          = "bid_igw",
    ngw          = "bid_ngw",
    public_rt    = "bid_public_rt",
    private_rt   = "bid_private_rt",
    beanstalk_sg = "bid_beanstalk_sg",
    lb           = "bid-lb",
    lb-tg1       = "bid-lb-tg-http",
    lb-tg2       = "bid-lb-tg-https",
    lb_sg        = "bid-lb_sg"

  }

  type        = map(string)
  description = "vpc names"
}

#azs
variable "azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
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

variable "def_egress_cidr" {
  default     = ["0.0.0.0/0"]
  description = "allow traffic from everywhere"
  type        = list(string)
}

variable "def_rt_cidr" {
  default = "0.0.0.0/0"
  type    = string
}

variable "bid_rt_name" {
  default = "bid-route-table"
  type    = string
}
variable "bid_gw_name" {
  default = "bid-gateway"
  type    = string
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

variable "eip_domain" {
  default   = "vpc"
  type      = string
  sensitive = true
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
variable "lb_out_cidrs" {
  default = ["10.10.2.0/24", "10.10.3.0/24", ]
  type    = list(string)
}

variable "beanstalk_sg" {

}

variable "subnet_for_lbs" {

}

variable "vpc_id" {

}

variable "lb_egress_cidrs" {

}

