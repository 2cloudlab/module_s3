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

resource "aws_s3_bucket_object" "object" {
  # https://stackoverflow.com/questions/57456167/uploading-multiple-files-in-aws-s3-from-terraform
  for_each     = var.static_web_site_folder != "" ? fileset(var.static_web_site_folder, "**") : []
  bucket       = var.bucket_name
  key          = each.value
  content_type = lookup(local.content_type_map, format(".%s", lower(reverse(concat(["unknown"], compact(split(".", basename(each.value)))))[0])), "application/octet-stream")
  source       = "${var.static_web_site_folder}${each.value}"
  etag         = filemd5("${var.static_web_site_folder}${each.value}")
  # https://stackoverflow.com/questions/58275233/terraform-depends-on-with-modules
  depends_on = [module.website]
}

# check out the whole content type list from https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
locals {
  content_type_map = {
    ".txt"     = "text/plain; charset=utf-8"
    ".html"    = "text/html; charset=utf-8"
    ".htm"     = "text/html; charset=utf-8"
    ".xhtml"   = "application/xhtml+xml"
    ".css"     = "text/css; charset=utf-8"
    ".js"      = "application/javascript"
    ".xml"     = "application/xml"
    ".json"    = "application/json"
    ".jsonld"  = "application/ld+json"
    ".gif"     = "image/gif"
    ".jpeg"    = "image/jpeg"
    ".jpg"     = "image/jpeg"
    ".png"     = "image/png"
    ".svg"     = "image/svg"
    ".webp"    = "image/webp"
    ".weba"    = "audio/webm"
    ".webm"    = "video/webm"
    ".3gp"     = "video/3gpp"
    ".3g2"     = "video/3gpp2"
    ".pdf"     = "application/pdf"
    ".swf"     = "application/x-shockwave-flash"
    ".atom"    = "application/atom+xml"
    ".rss"     = "application/rss+xml"
    ".ico"     = "image/vnd.microsoft.icon"
    ".jar"     = "application/java-archive"
    ".ttf"     = "font/ttf"
    ".otf"     = "font/otf"
    ".eot"     = "application/vnd.ms-fontobject"
    ".woff"    = "font/woff"
    ".woff2"   = "font/woff2"
    ".unknown" = "application/octet-stream"
  }
}
