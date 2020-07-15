terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.58"
  region  = "ap-northeast-1"
}

locals {
  s3_origin_id = "myS3Origin"
}

data "aws_s3_bucket" "selected" {
  bucket = "2cloudlab.example.com"
}

resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "2cloudlab.example.com"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = data.aws_s3_bucket.selected.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "diglods.top distribution"
  default_root_object = "index.html"

  aliases = ["digolds.top", "www.digolds.top"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "CN", "JP"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = "arn:aws:acm:us-east-1:120699691161:certificate/5a6cd92e-c199-4f52-9f04-b7b2b31089e4"
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
  }
}

output "distribution_location" {
  value = aws_cloudfront_distribution.s3_distribution
}
