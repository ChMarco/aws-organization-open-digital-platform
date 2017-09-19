/*
 * Module: Route53: Zone Association
 *
 * Outputs
 *
 */

output "id" {
    value = "${aws_route53_zone_association.route53_zone_association.id}"
}
