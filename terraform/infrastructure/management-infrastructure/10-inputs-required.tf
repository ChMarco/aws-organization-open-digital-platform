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

# Bastion
variable "bastion_public_key" {}
variable "bastion_ssh_whitelist" { type = "map" }
variable "provisioner_ssh_public_key" {}
variable "tag_bastion_resource_name" {}
variable "tag_bastion_project_name" {}
variable "tag_bastion_environment" {}
variable "tag_bastion_cost_center" {}
variable "tag_bastion_tier" {}
variable "tag_bastion_app_operations_owner" {}
variable "tag_bastion_system_owner" {}
variable "tag_bastion_budget_owner" {}

# Jenkins
variable "jenkins_image_tag" {}
variable "jenkins_public_key" {}
variable "jenkins_web_whitelist" { type = "map" }
variable "tag_jenkins_resource_name" {}
variable "tag_jenkins_project_name" {}
variable "tag_jenkins_environment" {}
variable "tag_jenkins_cost_center" {}
variable "tag_jenkins_tier" {}
variable "tag_jenkins_app_operations_owner" {}
variable "tag_jenkins_system_owner" {}
variable "tag_jenkins_budget_owner" {}

# Jenkins CodeBuild
variable "jenkins_codebuild_name" {}
variable "jenkins_codebuild_repo" {}
variable "jenkins_codebuild_ecr" {}
variable "jenkins_image_name" {}

variable "jenkins_slave_codebuild_name" {}
variable "jenkins_slave_codebuild_repo" {}
variable "jenkins_slave_codebuild_ecr" {}
variable "jenkins_slave_image_name" {}

# BitBucket
variable "bitbucket_public_key" {}
variable "bitbucket_web_whitelist" { type = "map" }

# Artifactory
variable "artifactory_public_key" {}
variable "artifactory_web_whitelist" { type = "map" }

# Monitoring
variable "monitoring_public_key" {}
variable "monitoring_web_whitelist" { type = "map" }
variable "tag_monitoring_resource_name" {}
variable "tag_monitoring_project_name" {}
variable "tag_monitoring_environment" {}
variable "tag_monitoring_cost_center" {}
variable "tag_monitoring_tier" {}
variable "tag_monitoring_app_operations_owner" {}
variable "tag_monitoring_system_owner" {}
variable "tag_monitoring_budget_owner" {}