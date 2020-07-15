terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-1"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "digolds.top"
  subject_alternative_names = ["*.digolds.top"]
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
}

output "aws_acm_certificate_instance" {
  value = aws_acm_certificate.cert
}
