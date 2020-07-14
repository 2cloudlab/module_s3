variable "bucket_name" {
  description = ""
  type        = string
}

variable "acl" {
  description = ""
  type        = string
}

variable "websites" {
  description = ""
  type        = any
  default = [{
    index_document           = "index.html"
    error_document           = "error.html"
    routing_rules            = <<EOF
    [{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
    }]
    EOF
    redirect_all_requests_to = null
  }]
}

variable "static_web_site_folder" {
  description = ""
  type        = string
}
