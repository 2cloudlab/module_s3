terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-1"
}

resource "aws_sns_topic" "topic" {
  for_each = {
    for i in var.topics :
    i.topic_name => i
  }
  name = each.key
  # check out the policy here https://docs.aws.amazon.com/AmazonS3/latest/dev/ways-to-add-notification-config-to-bucket.html
  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[
    {
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:${each.key}",
        "Condition": {
            "ArnLike": { "aws:SourceArn" : "arn:aws:s3:*:*:${var.bucket_name}" }
        }
    }]
}
POLICY
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  dynamic "topic" {
    for_each = var.topics
    content {
      topic_arn = aws_sns_topic.topic[topic.value["topic_name"]].arn
      events    = topic.value["events"]
      # only the object suffixed by .log can trigger the notification.
      filter_suffix = topic.value["filter_suffix"]
    }
  }
  depends_on = [aws_sns_topic.topic]
}
