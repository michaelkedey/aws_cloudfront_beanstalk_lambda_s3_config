#vpc_id
output "vpc_id" {
  value = aws_vpc.bid_vpc.id
}

#subnet_ids
output "sn_private1_id" {
  value = aws_subnet.sn_private1.id
}

output "sn_private2_id" {
  value = aws_subnet.sn_private2.id
}

output "sn_public1_id" {
  value = aws_subnet.sn_public1.id
}

output "sn_public2_id" {
  value = aws_subnet.sn_public2.id
}

#sg_ids
output "beanstalk_sg_id" {
  value = aws_security_group.beanstalk_sg.id
}

#beanstalk instances subnets
output "beanstalk_subnets" {
  #value = join(",", [aws_subnet.sn_private1.id, aws_subnet.sn_private2.id])
  value = [
    aws_subnet.sn_private1.id,
    aws_subnet.sn_private2.id
  ]
}

output "beanstalk_subnet_lists" {
  value = join(",", [aws_subnet.sn_private1.id, aws_subnet.sn_private2.id])

}

output "beanstalk_lb_subnet_lists" {
  value = join(",", [aws_subnet.sn_public1.id, aws_subnet.sn_public2.id])

}

output "beanstalk_sgs" {
  #value = join(",", [aws_security_group.beanstalk_sg.id])
  value = aws_security_group.beanstalk_sg.id
}


output "lb_out_cidrs" {
  value = [
    aws_subnet.sn_private1.cidr_block,
    aws_subnet.sn_private2.cidr_block,
  ]
}

output "vpc_cidr_block" {
  value = aws_vpc.bid_vpc.cidr_block
}
