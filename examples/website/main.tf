terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.58"
  region  = "ap-northeast-1"
}

module "website" {
  source                     = "../../modules/website"
  bucket_name                = "2cloudlab.example.com"
  acl                        = "public-read"
  static_web_site_folder     = "test_website/"
  origin_access_identity_arn = "arn:aws:cloudfront::120699691161:distribution/E3BB3N2TES5C14"
}

output "website_instance" {
  value = module.website.website_instance
}
