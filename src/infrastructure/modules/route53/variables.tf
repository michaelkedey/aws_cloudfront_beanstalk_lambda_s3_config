variable "beanstalk_elb_dns" {

}

variable "record_name_domain" {

}

variable "record_type" {
  default = "A"
}

variable "vpc_id" {
  description = "The VPC ID to create the record in."
}