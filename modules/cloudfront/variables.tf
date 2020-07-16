variable "acm_certificate_arn" {
  description = ""
  type        = string
}

variable "tags" {
  description = ""
  type        = map(string)
  default     = {}
}

variable "locations" {
  description = ""
  type        = list(string)
}

variable "cached_methods" {
  description = ""
  type        = list(string)
}

variable "allowed_methods" {
  description = ""
  type        = list(string)
}

variable "aliases" {
  description = ""
  type        = list(string)
}

variable "default_root_object" {
  description = ""
  type        = string
}

variable "comment" {
  description = ""
  type        = string
}

variable "bucket_regional_domain_name" {
  description = ""
  type        = string
}
