variable "aws_region" {}
variable "account_id" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "openvpn_public_key" {}
variable "openvpn_subnets" {}
variable "openvpn_ssh_bastion_access" {}
variable "openvpn_web_whitelist" {}

variable "openvpn_admin_user" { default = "provisioner" }
variable "openvpn_admin_pw" { default = "oV3NydFDRiBTxUuGAFjtLPoF" }

variable "monitoring_security_group" {}
variable "discovery_security_group" {}
variable "secrets_security_group" {}
variable "deploy_environment" {}

# Tags
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}