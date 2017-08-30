/*
 * Module: AutoScaling Group
 *
 * Outputs:
 *   -
 */

output "asg" {
  value = "${aws_autoscaling_group.asg.id}"
}