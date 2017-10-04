# General
variable "aws_region" {}
variable "account_id" {}
variable "deploy_environment" {}
variable "management_keypair" {}
variable "ssh_web_whitelist" {}
variable "jenkins_image_tag" {}
variable "vault_image_tag" {}
variable "consul_acl_master_token_uuid" {}

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