variable "aws_region" {}
variable "account_id" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "gocd_public_key" {}
variable "gocd_image_tag" {}
variable "gocd_subnets" {}
variable "gocd_elb_subnets" {}
variable "gocd_ssh_bastion_access" {}
variable "gocd_web_whitelist" {}

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