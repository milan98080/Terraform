data "aws_route53_zone" "selected" {
  name         = "my.app."
  private_zone = false
}

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "my.app"
  type    = "A"

  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = var.cloudfront_distribution_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "api.my.app"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}