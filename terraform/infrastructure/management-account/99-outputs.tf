output "vpc_outputs" {
  value = "${module.vpc.vpc_outputs}"
}

output "cloudtrail_outputs" {
  value = "${module.cloudtrail.cloudtrail_outputs}"
}

output "bastion_outputs" {
  value = "${module.bastion.bastion_outputs}"
}

output "jenkins_outputs" {
  value = "${module.jenkins.jenkins_outputs}"
}

output "bitbucket_outputs" {
  value = "${module.bitbucket.bitbucket_outputs}"
}