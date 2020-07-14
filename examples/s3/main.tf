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
  static_web_site_folder = "./"
}

output "website_instance" {
  value = module.website.website_instance
}
