output "distribution_location" {
  value = aws_cloudfront_distribution.s3_distribution
}

output "aws_cloudfront_origin_access_identity" {
  value = aws_cloudfront_origin_access_identity.default
}
