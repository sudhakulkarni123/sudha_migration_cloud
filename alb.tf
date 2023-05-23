resource "aws_lb" "migration_alb" {
  name               = "migration-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.internet_face.id]

}

resource "aws_security_group" "internet_face" {
  name        = "allow-tls"
  description = "allow tls inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from vpc"
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
    name = "allow all traffic"
  }
}

resource "aws_lb_listener" "front_end" {
  depends_on        = [aws_acm_certificate.acm_certificate]
  load_balancer_arn = aws_lb.migration_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  #certificate_arn = "arn:aws:acm:eu-west-1:217741831553:certificate/f3ee1939-5812-497a-8ed1-18cc17caf098"
  certificate_arn = aws_acm_certificate.acm_certificate.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "fixed response content"
      status_code  = "200"
    }
  }
}

#resource "aws_route53_record" "aliaslb" {
resource "aws_route53_record" "route53_records" {
  zone_id = aws_route53_zone.sudha_z.zone_id
  name    = "*.capci-grpb.aws.crlabs.cloud"
  type    = "A"

  alias {
    name                   = aws_lb.migration_alb.dns_name
    zone_id                = aws_lb.migration_alb.zone_id
    evaluate_target_health = true
  }
}