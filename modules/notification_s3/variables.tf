variable "bucket_name" {
  description = ""
  type        = string
  default     = "2cloudlab-bucket-name-in-the-field"
}

variable "topics" {
  description = ""
  type = list(object({
    topic_name    = string
    events        = list(string)
    filter_suffix = string
  }))
  default = [
    {
      topic_name    = "s3-event-notification-topic"
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = ".log"
    },
    {
      topic_name    = "s3-event-notification-topic-1"
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = ".jpeg"
    }
  ]
}
