data "aws_availability_zones" "available" {
    state = "available"
}

# data "aws_route53_zone" "route53_zone" {
#   name         = "capci-grpb.aws.crlabs.cloud"
#   private_zone = false
# }

data "aws_route53_zone" "sudha_z" {
  name = "sudha_mglab.aws.crlabs.cloud"
  vpc_id = module.vpc.vpc_id
  private_zone = false
}

