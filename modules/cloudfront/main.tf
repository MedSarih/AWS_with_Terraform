# Get the certificate from AWS ACM aws certif. manager
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# Update the ACM certificate data source
data "aws_acm_certificate" "issued" {
  domain     = var.certificate_domain_name
  statuses   = ["ISSUED"]
  most_recent = true
  
  # CRITICAL: ACM certificates for CloudFront must be in us-east-1
  provider = aws.us-east-1
}
#creating Cloudfront distribution :
resource "aws_cloudfront_distribution" "my_distribution" {
  enabled             = true
  aliases             =  ["medsinfo.xyz"]  #respond to a custom domain:www.medsinfo.xyz
  origin {
    domain_name = var.alb_domain_name
    origin_id   = var.alb_domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.alb_domain_name
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["MA","US"]
    }
  }
  tags = {
    Name = var.project_name
  }
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:058264317949:certificate/57d653f1-0189-4f85-b086-7b7ac0f9dcb2"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}