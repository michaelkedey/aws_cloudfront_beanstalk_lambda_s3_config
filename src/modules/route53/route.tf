resource "aws_route53_zone" "bid_zone" {
  name = "cloud.com"
  vpc { 
    vpc_id = var.vpc_id
  }
}

# resource "aws_route53_record" "bid_record" {
#   allow_overwrite = true
#   name            = "test.example.com"
#   ttl             = 300
#   type            = "NS"
#   zone_id         = aws_route53_zone.bid_zone.zone_id

#   records = [
#     aws_route53_zone.example.name_servers[0],
#     aws_route53_zone.example.name_servers[1],
#     aws_route53_zone.example.name_servers[2],
#     aws_route53_zone.example.name_servers[3],
#   ]
# }

resource "aws_route53_record" "bid_record" {
  zone_id = aws_route53_zone.bid_zone.zone_id
  name    = var.record_name
  type    = var.record_type

  alias {
    name                   = var.beanstalk_elb_dns
    zone_id                = aws_elb.bid_zone.zone_id
    evaluate_target_health = true
  }
}