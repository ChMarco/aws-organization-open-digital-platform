/*
 * Module: Route53 Private Zone
 *
 * Components:
 *   - route53_zone
 */

resource "aws_route53_zone" "route53_zone" {
  name = "${var.name}"
  comment = "${var.comment}"
  vpc_id = "${var.vpc_id}"

  tags = "${merge(
            data.null_data_source.tag_defaults.inputs,
            map(
            "Name", format("%s",
                var.name
            )
        )
    )}"
}