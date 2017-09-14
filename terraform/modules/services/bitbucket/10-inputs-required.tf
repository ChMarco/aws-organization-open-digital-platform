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

# Tags
variable "tag_resource_name" {}
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_tier" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}