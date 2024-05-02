variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the CloudFront distribution"
  type        = string
}

variable "distribution_enabled" {
  description = "Flag to enable or disable the CloudFront distribution"
  type        = bool
}

variable "distribution_default_root_object" {
  description = "The default root object for the CloudFront distribution"
  type        = string
}

variable "distribution_restriction_type" {
  description = "The type of restriction for the CloudFront distribution"
  type        = string
}

variable "distribution_geo_restriction_locations" {
  description = "List of locations for geo restriction in CloudFront distribution"
  type        = list(string)
}

variable "distribution_allowed_methods" {
  description = "List of allowed methods for the CloudFront distribution"
  type        = list(string)
}

variable "distribution_cached_methods" {
  description = "List of cached methods for the CloudFront distribution"
  type        = list(string)
}

variable "bucket_origin_id" {
  description = "The origin ID for the S3 bucket in CloudFront distribution"
  type        = string
}

variable "distribution_viewer_protocol_policy" {
  description = "The viewer protocol policy for the CloudFront distribution"
  type        = string
}

variable "distribution_forwarded_values_query_string" {
  description = "Flag to enable or disable forwarding of query strings in CloudFront"
  type        = bool
}

variable "distribution_forwarded_values_cookies_forward" {
  description = "Policy for forwarding cookies in CloudFront distribution"
  type        = string
}

variable "distribution_viewer_certificate_cloudfront_default_certificate" {
  description = "Flag to use CloudFront's default SSL/TLS certificate"
  type        = bool
}



