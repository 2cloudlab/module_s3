terraform {
  required_version = "= 0.12.19"
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  acl    = var.acl
  policy = var.policy

  dynamic "website" {
    for_each = var.websites
    content {
      index_document           = website.value["index_document"]
      error_document           = website.value["error_document"]
      routing_rules            = website.value["routing_rules"]
      redirect_all_requests_to = website.value["redirect_all_requests_to"]
    }
  }
}
