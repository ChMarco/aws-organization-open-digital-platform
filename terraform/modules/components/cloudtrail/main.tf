/*
 * Module: cloudtrail
 *
 * Components:
 *   - Cloudtrail S3 Bucket
 *   - Cloudtrail
 */

#--------------------------------------------------------------
# Cloudtrail
#--------------------------------------------------------------

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = "cloudtrail-${var.account_id}"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::cloudtrail-${var.account_id}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::cloudtrail-${var.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_cloudtrail" "cloudtrail" {
  name = "Default"
  s3_bucket_name = "cloudtrail-${var.account_id}"
  include_global_service_events = true
  is_multi_region_trail = true
  enable_log_file_validation = true

  depends_on = [
    "aws_s3_bucket.cloudtrail_bucket"
  ]
}