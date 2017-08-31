variable "aws_region" {}

variable "vpc_id" {}
variable "vpc_shortname" {}

variable "jenkins_public_key" {}
variable "jenkins_subnets" {}
variable "jenkins_elb_subnets" {}
variable "jenkins_ssh_bastion_access" {}
variable "jenkins_web_whitelist" { type = "map" default = {} }

variable "deploy_environment" {}
