/*
 * Module: AutoScaling Group
 *
 * Components:
 *   -
 */

resource "aws_autoscaling_group" "asg" {
  name = "${var.asg_name}"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"
  desired_capacity = "${var.desired_capacity}"
  availability_zones = [
    "${format("%s", element(data.aws_availability_zones.available.names, count.index))}"
    ]

  load_balancers = [
    "${var.elb}",
  ]
  launch_configuration = "${var.lc}"
  health_check_grace_period = "${var.healthcheck_grace_period}"
  health_check_type = "${var.health_check_type}"
  default_cooldown = "${var.cool_down_period}"
}
