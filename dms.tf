# Database Migration Service requires the below IAM Roles to be created before
# replication instances can be created. See the DMS Documentation for
#  * dms-vpc-role
#  * dms-cloudwatch-logs-role
#  * dms-access-for-endpoint

data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "dms-access-for-endpoint" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-access-for-endpoint"
}

resource "aws_iam_role_policy_attachment" "dms-access-for-endpoint-AmazonDMSRedshiftS3Role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
  role       = aws_iam_role.dms-access-for-endpoint.name
}

resource "aws_iam_role" "dms-cloudwatch-logs-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-cloudwatch-logs-role"
}

resource "aws_iam_role_policy_attachment" "dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  role       = aws_iam_role.dms-cloudwatch-logs-role.name
}

resource "aws_iam_role" "dms-vpc-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-vpc-role"
}

resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms-vpc-role.name
}

# Create a new replication instance
resource "aws_dms_replication_instance" "dms-replication-instance" {
  # checkov:skip=CKV_AWS_212: ADD REASON
  allocated_storage            = 20
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  availability_zone            = "eu-west-1a"
  engine_version               = "3.4.7"
  multi_az                     = false
  preferred_maintenance_window = "sun:10:30-sun:14:30"
  publicly_accessible          = false
  replication_instance_class   = "dms.t3.micro"
  replication_instance_id      = "dms-replication-instance"
  replication_subnet_group_id = aws_dms_replication_subnet_group.dms-replication-subnet-group.id

  tags = {
    Name = "dms-replication-instance"
  }

  vpc_security_group_ids = [aws_security_group.replication_sg.id,aws_security_group.rds_sg.id]
  depends_on = [
    aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role,
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]
}

# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "dms-replication-subnet-group" {
  replication_subnet_group_description = "replication subnet group"
  replication_subnet_group_id          = "dms-replication-subnet-group"

  subnet_ids = [
    "subnet-0a031f2fa60d29e72",
    "subnet-09633b51b70e50357",
  ]

  tags = {
    Name = "example"
  }
}


# SG group for repli instance
resource "aws_security_group" "replication_sg" {
  # checkov:skip=CKV_AWS_23: ADD REASON
  name        = "replication_sg"
  description = "Rds postgress sec group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "open port 5432"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    #security_groups = [aws_security_group.pgadmin_sg.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "open port 3306"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    #security_groups = [aws_security_group.pgadmin_sg.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "repli-server-sg"
  }
}



