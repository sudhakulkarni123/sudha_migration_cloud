locals {
  availability-zones      = slice(data.aws_availability_zones.available.names, 0,2)
  public_subnet_cidr      = cidrsubnet(var.vpc_cidr, 1, 0)
  private_subnet_cidr     = cidrsubnet(var.vpc_cidr, 1, 1)
  database_subnet_cidr    = cidrsubnet(var.vpc_cidr, 2, 1)
  #common_tags = "gitgub_action"

}