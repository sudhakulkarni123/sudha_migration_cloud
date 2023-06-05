#launch template
resource "aws_launch_template" "asg_template" {
  name                   = "asg_template"
  vpc_security_group_ids = [aws_security_group.pgadmin.id]
  image_id               = var.ami_id_for_asg
  instance_type          = "t2.micro"
  user_data              = filebase64("apache.sh")
}

#auto scaling group
resource "aws_autoscaling_group" "pgadmin_asg" {
  name                      = "cloud-auto-scaling-group"
  vpc_zone_identifier       = module.vpc.private_subnets
  desired_capacity          = 2
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 400
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.target_group_alb.arn]
  launch_template {
    id      = aws_launch_template.asg_template.id
    version = aws_launch_template.asg_template.latest_version
  }
}

resource "aws_security_group" "pgadmin" {
  name        = "pgadmin"
  description = "allow alb inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "alb from vpc"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.internet_face_alb.id]
  }

  ingress {
    description = "ssh connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = [var.cidr,var.onprem-cidr]
  }

  ingress {
    description = "http connection"
    from_port   = 80
    to_port     = 80
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
