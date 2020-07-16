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

module "cloudfront" {
  source                      = "../../modules/cloudfront"
  bucket_regional_domain_name = data.aws_s3_bucket.selected.bucket_regional_domain_name
  comment                     = "diglods.top distribution"
  default_root_object         = "index.html"
  aliases                     = ["digolds.top", "www.digolds.top"]
  allowed_methods             = ["GET", "HEAD", "OPTIONS"]
  cached_methods              = ["GET", "HEAD"]
  locations                   = ["US", "CA", "GB", "DE", "CN", "JP"]
  acm_certificate_arn         = "arn:aws:acm:us-east-1:120699691161:certificate/5a6cd92e-c199-4f52-9f04-b7b2b31089e4"
}

output "distribution_location" {
  value = module.cloudfront.distribution_location
}
