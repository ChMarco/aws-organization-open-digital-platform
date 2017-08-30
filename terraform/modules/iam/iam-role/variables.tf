/*
 * Module: iam-role
 *
 * Variables:
 *   - role_name
 *   - role_policy_document
 */

variable "role_name" {
  description = "The name of the policy"
}
variable "role_policy_document" {
  description = "The policy document (JSON)"
}