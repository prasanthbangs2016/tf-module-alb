#resource "aws_lb" "public" {
#  name               = "Roboshop-${var.env}-public"
#  internal           = false
#  load_balancer_type = "application"
#  security_groups    = [aws_security_group.public.id]
#  subnets            = var.public_subnets
#
#
#
#  tags = {
#    Environment = "Roboshop-${var.env}-public"
#  }
#}
#resource "aws_lb_target_group" "public" {
#  name     = "Frontend-${var.env}-public"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = var.vpc_id
#}
#
#resource "aws_lb_listener" "front_end-https" {
#  load_balancer_arn = aws_lb.public.arn
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = data.aws_acm_certificate.public.arn
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.public.arn
#  }
#}
#resource "aws_lb_listener" "front_end-http" {
#  load_balancer_arn = aws_lb.public.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type             = "forward"
#
#    redirect {
#      port = "443"
#      protocol = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}
#
#
#
#resource "aws_security_group" "public" {
#  name        = "roboshop-${var.env}-public-alb"
#  description = "roboshop-${var.env}-public-alb"
#  vpc_id      = var.vpc_id
#
#  ingress {
#    description      = "HTTP"
#    from_port        = 80
#    to_port          = 80
#    protocol         = "tcp"
#    cidr_blocks      = ["0.0.0.0/0"]
#
#  }
#  ingress {
#    description      = "HTTPS"
#    from_port        = 443
#    to_port          = 443
#    protocol         = "tcp"
#    cidr_blocks      = ["0.0.0.0/0"]
#
#  }
#
#
#  tags = {
#    Name = "Roboshop-${var.env}-public-alb"
#  }
#}
#
#resource "aws_route53_record" "public" {
#  zone_id = data.aws_route53_zone.public.id
#  name    = var.PUBLIC_DNS_RECORD
#  type    ="CNAME"
#  ttl     = 300
#  records = [aws_lb.public.dns_name]
#}
#
#
#resource "aws_lb" "private" {
#  name               = "Roboshop-${var.env}-private"
#  internal           = true
#  load_balancer_type = "application"
#  security_groups    = [aws_security_group.private.id]
#  subnets            = var.app_subnets
#
#
#
#  tags = {
#    Environment = "Roboshop-${var.env}-private-alb"
#  }
#}
#
#resource "aws_security_group" "private" {
#  name        = "roboshop-${var.env}-private-alb"
#  description = "roboshop-${var.env}-private-alb"
#  vpc_id      = var.vpc_id
#
#  ingress {
#    description      = "HTTP"
#    from_port        = 80
#    to_port          = 80
#    protocol         = "tcp"
#    cidr_blocks      = [var.vpc_cidr_block]
#
#  }
#
#
#  tags = {
#    Name = "Roboshop-${var.env}-private-alb"
#  }
#}