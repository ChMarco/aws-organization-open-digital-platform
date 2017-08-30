/*
 * Module: iam-policy-attachment
 *
 * Outputs:
 *   - policy_id
 */

output "policy_id" {
  value = "${aws_iam_policy_attachment.iam_policy_attachment.id}"
}
