resource "aws_lb" "public" {
  name               = "Roboshop-${var.env}-public"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public.id]
  subnets            = var.public_subnets



  tags = {
    Environment = "Roboshop-${var.env}"
  }
}

resource "aws_security_group" "public" {
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


  tags = {
    Name = "Roboshop-${var.env}-public-alb"
  }
}


resource "aws_lb" "private" {
  name               = "Roboshop-${var.env}-private"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private.id]
  subnets            = [var.vpc_cidr_block]



  tags = {
    Environment = "production"
  }
}

resource "aws_security_group" "private" {
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