# #RDS instance
# resource "aws_db_instance" "rds_migration_databse_instance" {
#   depends_on             = [aws_security_group.rds_sg]
#   instance_class          = "db.t3.medium"
#   db_name                 = "customer_db"
#   identifier              = "rds-database"
#   allocated_storage       = 20
#   storage_type            = "gp3"
#   engine                  = "postgres"
#   engine_version          = "15"
#   port                    = "5432"
#   backup_retention_period = 7
#   backup_window           = "11:00-12:00"
#   manage_master_user_password = true
#   db_subnet_group_name       = aws_db_subnet_group.database_subnet_group_name.id
#   username            = "var.rds_username"
#   auto_minor_version_upgrade = true
#   publicly_accessible        = false
#   deletion_protection        = true
#   skip_final_snapshot        = true
#   multi_az                   = false
#   storage_encrypted          = true
#   availability_zone          = "var.availability_zones"
#   apply_immediately          = true
#   vpc_security_group_ids     = [aws_security_group.rds_sg.id]
#   snapshot_identifier        = null
#   maintenance_window         = "Sun:10:00-Sun:11:00"
#   tags = {
#     name = "migration rds instance"
#   }
# }

resource "aws_db_instance" "migration-lab-rds-db-instance" {
  depends_on             = [aws_security_group.rds_sg]
  identifier             = "rds-database"
  db_name                = "cloud_db"
  engine                 = "postgres"
  engine_version         ="15"
  instance_class         = "db.t3.medium"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group_name.id
  multi_az               = false

  #Backuop with MW and retention settings
  backup_window              = "07:00-08:00"
  maintenance_window         = "Sun:10:00-Sun:11:00"
  backup_retention_period    = 7
  auto_minor_version_upgrade = true

  #DB Password settings
  manage_master_user_password = true
  username                    = var.db_username

  #Storage settings
  storage_type      = "gp3"
  allocated_storage = 20
  storage_encrypted = true
  publicly_accessible   = false
  skip_final_snapshot   = true
  copy_tags_to_snapshot = true
  deletion_protection   = false
  
  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time
    content {
      restore_time                  = restore_to_point_in_time.value["restore_time"]
      source_db_instance_identifier = restore_to_point_in_time.value["source_db_instance_identifier"]
      source_dbi_resource_id        = restore_to_point_in_time.value["source_dbi_resource_id"]
      use_latest_restorable_time    = restore_to_point_in_time.value["use_latest_restorable_time"]
    }

  }

  tags = {
    name = "migration-lab-db-instance"
}
}
resource "aws_db_subnet_group" "database_subnet_group_name" {
  name       = "migration-cloud-vpc-db-subnet-group"
  subnet_ids = ["subnet-0a031f2fa60d29e72", "subnet-09633b51b70e50357", ]
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "allow connection for rds server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "open port 5432"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.pgadmin.id]

  }

  ingress {
    description = "open asg ec2"
    from_port   = 20
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr,var.onprem-cidr]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "rds-server-sg"
  }
}
