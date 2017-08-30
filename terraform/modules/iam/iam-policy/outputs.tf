/*
 * Module: iam-policy
 *
 * Outputs:
 *   - policy_id
 *   - policy_arn
 */

output "policy_id" {
  value = "${aws_iam_policy.iam_policy.id}"
}

output "policy_arn" {
  value = "${aws_iam_policy.iam_policy.arn}"
}