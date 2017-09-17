variable "aws_region" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "bastion_public_key" {}
variable "bastion_subnets" {}
variable "bastion_ssh_whitelist" { type = "map" default = {} }

variable "provisioner_username" { default = "provisioner" }
variable "provisioner_ssh_public_key" {}

variable "monitoring_security_group" {}
variable "deploy_environment" {}

# Tags
variable "tag_resource_name" {}
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_service" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}