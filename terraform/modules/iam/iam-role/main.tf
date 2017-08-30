/*
 * Module: iam-role
 *
 * Components:
 *   - IAM Role
 */

resource "aws_iam_role" "iam_role" {
  name = "${var.role_name}"
  assume_role_policy = "${file("policies/${var.role_policy_document}.json")}"
}
