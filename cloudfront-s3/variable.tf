
variable "region" {
  description = "The AWS region where the S3 bucket should be created."
}

variable "cf_origin_access_identity_comment" {
  description = "Comment for the CloudFront Origin Access Identity"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
}

variable "cf_distribution_comment" {
  description = "Comment for the CloudFront distribution"
}

variable "cf_restriction_locations" {
  description = "List of locations for geo-restriction"
  type        = list(string)
}

