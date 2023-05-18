resource "aws_route53_record" "route53" {
  zone_id = aws_route53_zone.sudha_z.zone_id
  name    = "resolved-test"
  type    = "A"
  ttl     = 300
  records = ["10.0.0.0"]
  
}

resource "aws_route53_zone" "sudha_z" {
   name = "capci-grpb.aws.crlabs.cloud"
  
 }

