output "cloudfront_distribution_dns_name" {
  value       = aws_cloudfront_distribution.Site_Access.domain_name
  description = "The DNS name of the CloudFront distribution"
}

output "cloudfront_distribution_zone_id" {
  value = aws_cloudfront_distribution.Site_Access.hosted_zone_id
}
