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

#rt_ids
output "public_rt_id" {
  value = aws_route_table.bid_public_rt.id
}

output "private_rt_id" {
  value = aws_route_table.bid_private_rt.id
}

#igw_id
output "internet_gateway_id" {
  value = aws_internet_gateway.bid_gw.id
}

#ngw_id
output "nat_gateway_ids" {
  value = aws_nat_gateway.bid_ngw.id
}

# #lb
# output "load_balancer" {
#   value = aws_lb.bid_lb.name
# }

#beanstalk instances usbnets
output "beanstalk_subnets" {
  value = join(",", [aws_subnet.sn_private1.id, aws_subnet.sn_private2.id])
}

output "beanstalk_sgs" {
  value = aws_security_group.beanstalk_sg
}

# output "lambda_sn" {
#   value = toset([aws_subnet.sn_private1.id, aws_subnet.sn_private2.id])
# }

output "lb_out_cidrs" {
  value = join(",", [aws_subnet.sn_private1.id, aws_subnet.sn_private2.id])
}

output "vpc_cidr_block" {
  value = aws_vpc.bid_vpc.cidr_block
}

output "vpc_sns" {
  value = [aws_subnet.sn_private1.id, aws_subnet.sn_private2.id]
}
