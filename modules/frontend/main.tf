resource "aws_s3_bucket" "Site_Origin" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "origin" {
  depends_on = [
    aws_cloudfront_distribution.Site_Access
  ]
  bucket = aws_s3_bucket.Site_Origin.id
  policy = data.aws_iam_policy_document.origin.json
}

data "aws_iam_policy_document" "origin" {
  depends_on = [
    aws_cloudfront_distribution.Site_Access,
    aws_s3_bucket.Site_Origin
  ]
  statement {
    sid    = "3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.Site_Origin.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.Site_Access.arn
      ]
    }
  }
}

resource "aws_s3_bucket_versioning" "Site_Origin" {
  bucket = aws_s3_bucket.Site_Origin.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_cloudfront_distribution" "Site_Access" {
  depends_on = [
    aws_s3_bucket.Site_Origin,
    aws_cloudfront_origin_access_control.Site_Access
  ]
  aliases = [var.domain_name]
  origin {
    domain_name              = aws_s3_bucket.Site_Origin.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.Site_Origin.id
    origin_access_control_id = aws_cloudfront_origin_access_control.Site_Access.id
  }

  enabled             = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.Site_Origin.id
    viewer_protocol_policy = "https-only"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}


resource "aws_cloudfront_origin_access_control" "Site_Access" {
  name                              = "CF_S3_OAC"
  description                       = "OAC setup"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}