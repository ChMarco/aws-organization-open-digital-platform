variable "aws_region" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "discovery_public_key" {}
variable "discovery_subnets" {}
variable "discovery_elb_subnets" {}
variable "discovery_ssh_bastion_access" {}
variable "discovery_web_whitelist" {}
variable "consul_acl_master_token_uuid" {}

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