output "vpc_outputs" {
  value = "${module.vpc.vpc_outputs}"
}

output "vpc_peering_id" {
  value = "${module.vpc_peering.vpc_peering_id}"
}