/*
 * Module: iam-policy
 *
 * Components:
 *   - IAM Policy
 */

resource "aws_iam_policy" "iam_policy" {
  name = "${var.policy_name}"
  path = "/"
  description = "${var.policy_description}"
  policy = "${file("policies/${var.policy_document}.json")}"
}