# General
variable "aws_region" {}

# CloudTrail
variable "cloudtrail_bucket_name" {}

# Jenkins CodeBuild
variable "jenkins_codebuild_name" {}
variable "jenkins_codebuild_repo" {}
variable "jenkins_codebuild_ecr" {}
variable "jenkins_image_name" {}

variable "jenkins_slave_codebuild_name" {}
variable "jenkins_slave_codebuild_repo" {}
variable "jenkins_slave_codebuild_ecr" {}
variable "jenkins_slave_image_name" {}
