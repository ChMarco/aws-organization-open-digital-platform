output "cloudtrail_outputs" {
  value = "${module.cloudtrail.cloudtrail_outputs}"
}

output "codebuild_jenkins_outputs" {
  value = "${module.codebuild_jenkins.codebuild_outputs}"
}

output "codebuild_jenkins_slave_outputs" {
  value = "${module.codebuild_jenkins_slave.codebuild_outputs}"
}
