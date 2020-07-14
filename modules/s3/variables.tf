variable "bucket_name" {
  description = ""
  type        = string
}

variable "acl" {
  description = ""
  type        = string
}

variable "policy" {
  description = ""
  type        = string
}

variable "websites" {
  description = ""
  type        = any
  default     = []
}
