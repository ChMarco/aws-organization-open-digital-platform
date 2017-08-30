/*
 * Module: cloudtrail
 *
 * Components:
 *   - Cloudtrail
 */

#--------------------------------------------------------------
# Cloudtrail
#--------------------------------------------------------------
resource "aws_cloudtrail" "cloudtrail" {
  name = "Default"
  s3_bucket_name = "${var.s3_bucket}"
  include_global_service_events = true
  is_multi_region_trail = true
  enable_log_file_validation = true
}