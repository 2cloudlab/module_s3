terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.58"
  region  = "us-east-1"
}

module "website_certification" {
  source                    = "../../modules/https_certification"
  domain_name               = "digolds.top"
  subject_alternative_names = ["*.digolds.top"]
}

output "website_certification" {
  value = module.website_certification.website_certification
}
