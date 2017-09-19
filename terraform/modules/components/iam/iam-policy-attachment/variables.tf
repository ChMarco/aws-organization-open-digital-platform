/*
 * Module: iam-policy-attachment
 *
 * Variables:
 *   - policy_attachment_name
 *   - policy_roles
 *   - policy_users
 *   - policy_arn
 */

variable "policy_attachment_name" {
  description = "The name of the policy. This cannot be an empty string"
}
variable "policy_roles" {
  type = "list"
  description = "The role(s) the policy should be applied to"
}
variable "policy_users" {
  type = "list"
  description = "The user(s) the policy should be applied to"
}
variable "policy_groups" {
  type = "list"
  description = "The groups(s) the policy should be applied to"
}
variable "policy_arn" {
  description = "The ARN of the policy you want to apply"
}