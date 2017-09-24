variable "aws_region" {}
variable "account_id" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "jenkins_public_key" {}
variable "jenkins_image_tag" {}
variable "jenkins_subnets" {}
variable "jenkins_elb_subnets" {}
variable "jenkins_ssh_bastion_access" {}
variable "jenkins_web_whitelist" {}

variable "monitoring_security_group" {}
variable "discovery_security_group" {}
variable "deploy_environment" {}

# Tags
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}