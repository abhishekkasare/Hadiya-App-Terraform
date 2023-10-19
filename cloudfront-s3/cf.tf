
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.cf_origin_access_identity_comment
}

resource "aws_s3_bucket" "mybucket" {
  bucket = var.s3_bucket_name
  acl    = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
}

resource "aws_cloudfront_distribution" "my_cloudfront_distribution" {
  origin {
    domain_name = aws_s3_bucket.mybucket.bucket_regional_domain_name
    origin_id   = "S3Origin"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.cf_distribution_comment
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false

    cookies {
        forward = "none"  # Specify how you want to handle cookies
      }
    }	

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.cf_restriction_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

