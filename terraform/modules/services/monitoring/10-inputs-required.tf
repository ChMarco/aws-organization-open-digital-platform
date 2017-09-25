variable "aws_region" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "monitoring_public_key" {}
variable "monitoring_subnets" {}
variable "monitoring_elb_subnets" {}
variable "monitoring_ssh_bastion_access" {}
variable "monitoring_web_whitelist" {}

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