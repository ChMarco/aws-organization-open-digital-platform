output "vpc_outputs" {
  value = "${module.vpc.vpc_outputs}"
}

output "bastion_outputs" {
  value = "${module.bastion.bastion_outputs}"
}

output "jenkins_outputs" {
  value = "${module.jenkins.jenkins_outputs}"
}

output "monitoring_outputs" {
  value = "${module.monitoring.monitoring_outputs}"
}

output "discovery_outputs" {
  value = "${module.discovery.discovery_outputs}"
}

//output "secrets_outputs" {
//  value = "${module.secrets.secrets_outputs}"
//}