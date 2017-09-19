/*
 * Module: Route53: Record
 *
 * Outputs
 *
 */

output "fqdn" {
  value = "${aws_route53_record.route53_record.fqdn}"
}
