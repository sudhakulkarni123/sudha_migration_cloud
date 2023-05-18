#resource "aws_route53_record" "route53" {
 # zone_id = aws_route53_zone.primary.zone_id
 # name    = "capci-grpB.aws.crlabs.cloud"
 # type    = "A"
  #ttl     = 300
 # records = [aws_eip.lb.public_ip]
#}


# resource "aws_route53_zone" "primaryr53" {
#   name = "capci-grpb.aws.crlabs.cloud"
  
# }