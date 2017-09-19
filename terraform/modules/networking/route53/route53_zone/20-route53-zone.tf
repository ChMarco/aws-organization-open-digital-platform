/*
 * Module: Route53: Zone
 *
 * Components:
 *
 */

resource "aws_route53_zone" "route53_zone" {
    name = "${var.name}"
    comment = "${var.comment}"
    vpc_id = "${var.vpc_id}"
    tags {
        Name = "${var.tags_Name}"
        Environment = "${var.tags_Environment}"
        Created_By= "${var.tags_Created_By}"
    }
}
