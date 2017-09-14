variable "aws_region" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "jenkins_public_key" {}
variable "jenkins_image_tag" {}
variable "jenkins_subnets" {}
variable "jenkins_elb_subnets" {}
variable "jenkins_ssh_bastion_access" {}
variable "jenkins_web_whitelist" { type = "map" default = {} }

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