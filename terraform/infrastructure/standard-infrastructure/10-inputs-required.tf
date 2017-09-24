# General
variable "aws_region" {}
variable "management_keypair" {}
variable "deploy_environment" {}
variable "ssh_web_whitelist" {}

# VPC
variable "vpc_description" {}
variable "vpc_shortname" {}
variable "vpc_cidr_block" {}
variable "dmz_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}
variable "private_subnet_cidr_blocks" {}

variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}

# VPC Peer
variable "mgmt_vpc_id" {}
variable "mgmt_vpc_cidr" {}