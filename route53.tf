resource "aws_route53_zone" "nsrec" {
  name = "subhasri.aws.crlabs.cloud"

  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "privatea_rec" {
  zone_id = aws_route53_zone.nsrec.zone_id
  name    = "resolve-test"
  type    = "A"
  ttl     = 300
  records = [local.private_random_ip]
  
}