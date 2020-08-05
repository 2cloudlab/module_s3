terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.58"
  region  = "ap-northeast-1"
}

module "website" {
  source                 = "../../modules/website"
  bucket_name            = "2cloudlab.example.com"
  acl                    = "public-read"
  static_web_site_folder = "test_website/"
  # In order to restrict users directly access to your static website by s3's website_endpoint,
  # uncomment below command after created cloudfront,
  # then specific the generated origin_access_identity arn and re-run this code
  # origin_access_identity_arn = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3PK5Q3TDLDPJC"
}

output "website_instance" {
  value = module.website.website_instance
}
