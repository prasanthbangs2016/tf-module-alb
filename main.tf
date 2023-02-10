#1
resource "aws_lb" "public-alb" {
  name               = "Roboshop-${var.env}-public"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-alb.id]
  subnets            = var.public_subnets



  tags = {
    Environment = "Roboshop-${var.env}-public"
  }
}
#2
resource "aws_security_group" "public-alb" {
  name        = "roboshop-${var.env}-public-alb"
  description = "roboshop-${var.env}-public-alb"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    #exposing to public as it is external
    cidr_blocks      = ["0.0.0.0/0"]

  }
#all traffic allowed from public
  egress {
    description      = "All-traffic-outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    #exposing to public as it is external
    cidr_blocks      = ["0.0.0.0/0"]

  }


  tags = {
    Name = "Roboshop-${var.env}-public-alb"
  }
}

#3listener for https
resource "aws_lb_listener" "public-https" {
  load_balancer_arn = aws_lb.public-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #getting acm arn using data source
  certificate_arn   = data.aws_acm_certificate.public.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public.arn
  }
}

#4 pulling dns name from data and assigning it here.
#creating dns record for alb public (records)
resource "aws_route53_record" "public" {
  zone_id = data.aws_route53_zone.public.id
  name    = var.PUBLIC_DNS_RECORD
  type    ="CNAME"
  ttl     = 300
  records = [aws_lb.public-alb.dns_name]
}
#5 tgt group 80 ,group of instances ur going to attach
#this has been added as part app module as it should add only when it is frontend
#resource "aws_lb_target_group" "public" {
#  name     = "frontend-${var.env}-tg"
#  # target group backend is opened with 80port hence the same"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = var.vpc_id
#}

#6 if anyone hitting http,redirect to https(if anyone hitting 80 port redirect to https)

resource "aws_lb_listener" "public-http" {
  load_balancer_arn = aws_lb.public-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


#1
resource "aws_lb" "private-alb" {
  name               = "Roboshop-${var.env}-private"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private-alb.id]
  #as it is internal hence assigned to app subnets
  subnets            = var.app_subnets



  tags = {
    Environment = "Roboshop-${var.env}-private-alb"
  }
}
#2
resource "aws_security_group" "private-alb" {
  name        = "roboshop-${var.env}-private-alb"
  description = "roboshop-${var.env}-private-alb"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]

  }


  tags = {
    Name = "Roboshop-${var.env}-private-alb"
  }
}


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








