resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ialb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "production"
  }
}

resource "aws_security_group" "ialb" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-all-traffic"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = resource.aws_acm_certificate.migcert.arn

    default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
}
    
  tags = {
    Name = "Port443_listener"
  }
}

resource "aws_route53_record" "privatearec" {
    zone_id = data.aws_route53_zone.route53.id
    name = "resolve"
    type = "A"
    ttl = 300
    records = [local.private_random_ip]
}

resource "aws_route53_record" "aliaslb" {
    #zone_id = aws_route53_zone.public_member.zone_id
    zone_id = data.aws_route53_zone.route53.id
    name    = "subhasri.aws.crlabs.cloud"
    type    = "A"
  
    alias {
    name                   = aws_lb.test.dns_name
    zone_id                = aws_lb.test.zone_id
    evaluate_target_health = true
    }
}