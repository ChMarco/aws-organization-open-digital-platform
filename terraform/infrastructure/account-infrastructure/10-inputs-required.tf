# General
variable "aws_region" {}

variable "account_id" {}

# Jenkins CodeBuild
variable "jenkins_codebuild_name" {}
variable "jenkins_codebuild_repo" {}
variable "jenkins_image_name" {}

variable "jenkins_slave_codebuild_name" {}
variable "jenkins_slave_codebuild_repo" {}
variable "jenkins_slave_image_name" {}
