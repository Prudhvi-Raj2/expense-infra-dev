#*.kambalas.shop
#frontend.kambalas.shop
#backend.kambalas.shop 
resource "aws_acm_certificate" "expense" {
  domain_name = "*.${var.domain_name}"
  validation_method = "DNS"
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-acm-cert"
    }
)
}
resource "aws_route53_record" "expense" {
  for_each = {
    for dvo in aws_acm_certificate.expense.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}
resource "aws_acm_certificate_validation" "expense" {
  certificate_arn         = aws_acm_certificate.expense.arn
  validation_record_fqdns = [for record in aws_route53_record.expense : record.fqdn]
}