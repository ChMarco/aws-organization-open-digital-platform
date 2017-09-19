/*
 * Module: iam-policy
 *
 * Variables:
 *   - policy_name
 *   - policy_description
 *   - policy_document
 */

variable "policy_name" {
  description = "The name of the policy"
}
variable "policy_description" {
  description = "Description of the IAM policy."
}
variable "policy_document" {
  description = "The policy document (JSON)"
}