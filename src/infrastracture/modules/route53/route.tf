resource "aws_route53_zone" "bid_zone" {
  name = var.record_name_domain
  # vpc {
  #   vpc_id = var.vpc_id
  # }
}

resource "aws_route53_record" "bid_record" {
  zone_id = aws_route53_zone.bid_zone.zone_id
  name    = var.record_name_domain
  type    = var.record_type
  ttl     = "30"
  records = aws_route53_zone.bid_zone.name_servers

  alias {
    name                   = var.beanstalk_elb_dns
    zone_id                = aws_route53_zone.bid_zone.zone_id
    evaluate_target_health = true
  }
}