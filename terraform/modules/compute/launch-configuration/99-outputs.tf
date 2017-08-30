/*
 * Module: lc
 *
 * Outputs:
 *   - lc
 */

output "lc" {
  value = "${aws_launch_configuration.lc.id}"
}