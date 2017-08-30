/*
 * Module: iam-policy-attachment
 *
 * Components:
 *   - IAM Policy Attachment
 */

resource "aws_iam_policy_attachment" "iam_policy_attachment" {
  name = "${var.policy_attachment_name}"
  roles = [
    "${var.policy_roles}"
  ]
  users = [
    "${var.policy_users}"
  ]
  groups = [
    "${var.policy_groups}"
  ]
  policy_arn = "${var.policy_arn}"
}
