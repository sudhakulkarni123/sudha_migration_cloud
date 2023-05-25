# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = var.vpc_name
#   cidr = var.vpc_cidr

#   azs                        = local.availability-zones
#   private_subnets            = [for i, v in local.availability-zones : cidrsubnet(local.private_subnet_cidr, 2, i)]
#   public_subnets             = [for i, v in local.availability-zones : cidrsubnet(local.public_subnet_cidr, 2, i)]
#   database_subnets           = [for i, v in local.availability-zones : cidrsubnet(local.database_subnet_cidr, 2, i)]
#   database_subnet_group_name = var.database_subnet_group_name
#   enable_nat_gateway         = true
#   enable_vpn_gateway         = true
#   single_nat_gateway         = true
#   one_nat_gateway_per_az     = false

#   tags = var.tags
# }

# data "aws_availability_zones" "az" {
#   state = "available"
# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  # VPC Basic Details
  name                    = var.vpc_name
  cidr                    = var.cidr
  azs                     = var.availability_zones
  private_subnets         = var.private_subnets_cidr
  public_subnets          = var.public_subnets_cidr
  private_subnet_names    = var.private_subnet_names
  public_subnet_names     = var.public_subnet_names
  map_public_ip_on_launch = true

  # Overriding names of default resorces
  default_network_acl_name    = "migration-cloud-vpc-nacl"
  default_route_table_name    = "migration-cloud-vpc-default-rt"
  default_security_group_name = "migration-cloud-vpc-default-sg"

  # Database Subnets
  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  database_subnets                   = var.database_subnets_cidr
  database_subnet_names              = var.database_subnet_names
  database_subnet_group_name         = "migration-cloud-vpc-db-subnet-group"

  #create_database_nat_gateway_route = true
  #create_database_internet_gateway_route = true

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true


  # Enable vpc flow logs using s3 bucket
  # enable_flow_log                   = true
  # flow_log_destination_type         = "s3"
  # flow_log_file_format              = "plain-text"
  # flow_log_max_aggregation_interval = 60
  # flow_log_per_hour_partition       = true
  # flow_log_traffic_type             = "ALL"
  #flow_log_destination_arn          = "arn:aws:s3:::aws-logs-${local.account_id}-${local.region_name}"

  # Configuring required tags to provide custom value
  public_subnet_tags = {
    Type = "public-subnets"
  }

  private_subnet_tags = {
    Type = "private-subnets"
  }

  database_subnet_tags = {
    Type = "database-subnets"
  }

  nat_eip_tags = {
    Name = "migration-cloud-vpc-nat-eip"
  }

  nat_gateway_tags = {
    Name = "migration-cloud-vpc-nat-gw"
  }

  igw_tags = {
    Name = "migration-cloud-vpc-igw"
  }

  vpc_tags = {
    Name = "migration-cloud-vpc"
  }

  private_route_table_tags = {
    Name = "migration-cloud-vpc-private-route-table"
  }

  public_route_table_tags = {
    Name = "migration-cloud-vpc-public-route-table"
  }

  database_route_table_tags = {
    Name = "migration-cloud-vpc-database-route-table"
  }

  tags = var.tags
}