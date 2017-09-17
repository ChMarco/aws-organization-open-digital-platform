# General
variable "aws_region" {}
variable "deploy_environment" {}

# VPC
variable "vpc_description" {}
variable "vpc_shortname" {}
variable "vpc_cidr_block" {}
variable "dmz_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}
variable "private_subnet_cidr_blocks" {}

variable "tag_resource_name" {}
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_tier" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}

# VPC Peer
variable "mgmt_vpc_id" {}
variable "mgmt_vpc_cidr" {}

# Bastion
variable "bastion_public_key" {}
variable "bastion_ssh_whitelist" { type = "map" }
variable "provisioner_ssh_public_key" {}
variable "tag_bastion_resource_name" {}
variable "tag_bastion_project_name" {}
variable "tag_bastion_environment" {}
variable "tag_bastion_cost_center" {}
variable "tag_bastion_service" {}
variable "tag_bastion_app_operations_owner" {}
variable "tag_bastion_system_owner" {}
variable "tag_bastion_budget_owner" {}