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
variable "jenkins_public_key" {}
variable "jenkins_web_whitelist" { type = "map" }

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

# Consul
variable "consul_public_key" {}