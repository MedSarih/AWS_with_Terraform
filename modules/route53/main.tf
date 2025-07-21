# Create the hosted zone
resource "aws_route53_zone" "public-zone" {
  name = var.hosted_zone_name
  
  tags = {
    Name = "Public zone for ${var.hosted_zone_name}"
  }
}

# Create the CloudFront record
resource "aws_route53_record" "cloudfront_record" {
  zone_id = aws_route53_zone.public-zone.zone_id  # Reference the resource, not data
  name    = "medproject.${aws_route53_zone.public-zone.name}"
  type    = "A"
  
  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# Add the ACM validation record
resource "aws_route53_record" "cert_validation" {
  zone_id = aws_route53_zone.public-zone.zone_id
  name    = "_b5eb3f0e6c05fe0f7277e5c331befa53.${aws_route53_zone.public-zone.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["_c8888781811b10ebfb5728663ed354a3.xlfgrmvvlj.acm-validations.aws."]
}