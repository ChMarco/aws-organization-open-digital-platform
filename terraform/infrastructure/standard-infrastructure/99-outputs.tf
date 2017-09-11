output "vpc_outputs" {
  value = "${module.vpc.vpc_outputs}"
}

output "cloudtrail_outputs" {
  value = "${module.cloudtrail.cloudtrail_outputs}"
}

output "bastion_outputs" {
  value = "${module.bastion.bastion_outputs}"
}