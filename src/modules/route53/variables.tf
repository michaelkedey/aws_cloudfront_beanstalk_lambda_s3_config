variable "beanstalk_elb_dns" {

}

variable "record_name" {
  default = "www.adsf.com"
}

variable "record_type" {
  default = "A"
}

variable "vpc_id" {
  description = "The VPC ID to create the record in."
}