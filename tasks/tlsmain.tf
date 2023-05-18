# configured aws provider with proper credentials
#provider "aws" {
 # region    = eu-west-1
 # profile   = "sudha-migration-lab"
#}

# request public certificates from the amazon certificate manager.
resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = "sudha_mglab.aws.crlabs.cloud"
  subject_alternative_names = ["*.sudha_mglab.aws.crlabs.cloud"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# get details about a route 53 hosted zone
# data "aws_route53_zone" "route53_zones" {
#   name         = "capci-grpb.aws.crlabs.cloud"
#   vpc_id = module.vpc.vpc_id
#   private_zone = false
# }

# create a record set in route 53 for domain validatation
resource "aws_route53_record" "route53_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.sudha_z.zone_id
}

 #validate acm certificates
 resource "aws_acm_certificate_validation" "acm_certificate_validation" {
   certificate_arn         = aws_acm_certificate.acm_certificate.arn
   validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
 }

resource "time_sleep" "wait_30_seconds" {
   depends_on = [ aws_route53_record.route53_record ]
   create_duration = "120s"
}