/*
 * Module: Route53: Zone
 *
 * Outputs
 *
 */

output "id" {
    value = "${aws_route53_zone.route53_zone.zone_id}"
}
