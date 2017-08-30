/*
 * Module: Route53: Record Alias
 *
 * Outputs
 *
 */

output "fqdn" {
  value = "${aws_route53_record.route53_record.fqdn}"
}
