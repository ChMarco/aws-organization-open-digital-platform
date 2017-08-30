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

# CloudTrail
variable "cloudtrail_bucket_name" {}

# Bastion
variable "bastion_public_key" {}
variable "bastion_ssh_whitelist" { type = "map" }
variable "provisioner_ssh_public_key" {}

# Jenkins
