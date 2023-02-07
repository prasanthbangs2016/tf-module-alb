data "aws_route53_zone" "public" {
  name         = "devopsppk.online"
  private_zone = true
}

data "aws_acm_certificate" "public" {
  domain   = "*.devopsppk.online"
  statuses = ["ISSUED"]
}