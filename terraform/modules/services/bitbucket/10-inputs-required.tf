variable "aws_region" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "bitbucket_public_key" {}
variable "bitbucket_subnets" {}
variable "bitbucket_elb_subnets" {}
variable "bitbucket_rds_subnets" {}
variable "bitbucket_ssh_bastion_access" {}
variable "bitbucket_web_whitelist" { type = "map" default = {} }

variable "deploy_environment" {}
