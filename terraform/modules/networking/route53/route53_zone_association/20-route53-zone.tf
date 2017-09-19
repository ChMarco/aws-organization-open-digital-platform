/*
 * Module: Route53: Zone Association
 *
 * Components:
 *
 */

resource "aws_route53_zone_association" "route53_zone_association" {
    zone_id = "${var.zone_id}"
    vpc_id = "${var.vpc_id}"
    vpc_region = "${var.vpc_region}"
}