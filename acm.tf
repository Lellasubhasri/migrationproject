resource "aws_acm_certificate" "migcert" {
    domain_name = "subhasri.aws.crlabs.cloud"
    validation_method = "DNS"

    tags = {
    Environment = "test"
}

lifecycle {
    create_before_destroy = true
} 
}

resource "aws_route53_record" "route53_record" {
for_each = {
    for dvo in aws_acm_certificate.migcert.domain_validation_options : dvo.domain_name => {
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
#zone_id         = data.aws_route53_zone.route53_zone.zone_id
zone_id =  data.aws_route53_zone.route53.id
}


resource "aws_acm_certificate_validation" "acm_certificate_validation" {
certificate_arn         = aws_acm_certificate.migcert.arn
validation_record_fqdns = [for record in aws_route53_record.route53_record: record.fqdn]
}