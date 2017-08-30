/*
 * Module: cloudtrail
 *
 * Outputs:
 *   - cloudtrail_id
 *   - cloudtrail_home_region
 *   - cloudtrail_arn
 */

output "cloudtrail_id" {
  value = "${aws_cloudtrail.cloudtrail.id}"
}

output "cloudtrail_home_region" {
  value = "${aws_cloudtrail.cloudtrail.home_region}"
}

output "cloudtrail_arn" {
  value = "${aws_cloudtrail.cloudtrail.arn}"
}