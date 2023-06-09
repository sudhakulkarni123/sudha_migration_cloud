#loadbalancer creation
resource "aws_lb" "migration_alb_cloud" {
  #checkov
  name               = "migration-alb-cloud"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.internet_face_alb.id]
}

#security group for alb
resource "aws_security_group" "internet_face_alb" {
  name        = "allow-tls-alb-internatefacing"
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
    description      = "TLS from vpc"
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

# Listener for port 80
resource "aws_lb_listener" "alb_listener_80" {
  load_balancer_arn = aws_lb.migration_alb_cloud.arn
  port              = "80"
  protocol          = "HTTP"
  #   default_action {
  #     type             = "forward"
  #     target_group_arn = aws_lb_target_group.target_group_alb.arn
  #   }
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_target_group" "target_group_alb" {
  name     = "pgadmin-server-tg-alb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    port                = 80
    #protocol = "HTTP"
    # timeout  = 5
    # interval = 10
  }
}
#listner for alb
resource "aws_lb_listener" "front_end" {
  depends_on        = [aws_acm_certificate.acm_certificate]
  load_balancer_arn = aws_lb.migration_alb_cloud.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:eu-west-1:217741831553:certificate/0edb19ff-2af5-47dd-9d7a-7ae934dba275"
  #certificate_arn = aws_acm_certificate.acm_certificate.arn

  default_action {
    type = "forward"
    #target_group_arn = aws_lb_target_group.target_group_alb.arn
    target_group_arn = aws_lb_target_group.target_group_alb.arn
  }
}
# default_action {
#   type = "fixed-response"

#   fixed_response {
#     content_type = "text/plain"
#     message_body = "fixed response content"
#     status_code  = "200"
#   }
# }

#resource "aws_route53_record" "aliaslb" {
resource "aws_route53_record" "route53_records" {
  zone_id = aws_route53_zone.sudha_z.zone_id
  name    = "*.capci-grpb.aws.crlabs.cloud"
  type    = "A"

  alias {
    name                   = aws_lb.migration_alb_cloud.dns_name
    zone_id                = aws_lb.migration_alb_cloud.zone_id
    evaluate_target_health = true
  }
}