/*
 * Module: iam-role
 *
 * Outputs:
 *   - role_arn
 *   - role_unique_id
 */

output "role_arn" {
  value = "${aws_iam_role.iam_role.id}"
}

output "role_unique_id" {
  value = "${aws_iam_role.iam_role.unique_id}"
}