terraform {
  required_version = "= 0.12.19"
}

module "website" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
  acl         = var.acl
  # check out here: https://learn.hashicorp.com/terraform/aws/iam-policy for policy expressions
  policy   = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
POLICY
  websites = var.websites
}

# https://stackoverflow.com/questions/57456167/uploading-multiple-files-in-aws-s3-from-terraform
resource "aws_s3_bucket_object" "object" {
  for_each = fileset(var.static_web_site_folder, "*")
  bucket   = var.bucket_name
  key      = each.value
  source   = "${var.static_web_site_folder}${each.value}"
  etag     = filemd5("${var.static_web_site_folder}${each.value}")
}
