module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = local.availability-zones
  private_subnets = [for i, v in local.availability-zones : cidrsubnet(local.private_subnet_cidr, 2, i)]
  public_subnets  = [for i, v in local.availability-zones : cidrsubnet(local.public_subnet_cidr, 2, i)]
  database_subnets = [for i, v in local.availability-zones : cidrsubnet(local.database_subnet_cidr, 2, i)]
  database_subnet_group_name = var.database_subnet_group_name
  enable_nat_gateway = true
  enable_vpn_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = var.tags
}

data "aws_availability_zones" "az" {
    state = "available"
}