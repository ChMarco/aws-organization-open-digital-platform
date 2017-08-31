variable "aws_region" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "bastion_public_key" {}
variable "bastion_subnets" {}
variable "bastion_ssh_whitelist" { type = "map" default = {} }

variable "provisioner_username" { default = "provisioner" }
variable "provisioner_ssh_public_key" {}

variable "deploy_environment" {}
