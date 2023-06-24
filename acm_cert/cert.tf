resource "aws_acm_certificate" "os_domain_certificate" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name = "${var.domain_name}-Certificate"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for ecs in aws_acm_certificate.os_domain_certificate.domain_validation_options : ecs.domain_name => {
      name   = ecs.resource_record_name
      record = ecs.resource_record_value
      type   = ecs.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "ecs_domain_certificate_validation" {
  certificate_arn         = aws_acm_certificate.os_domain_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

output "certificate_arn" {
  value = aws_acm_certificate.os_domain_certificate.arn
}
