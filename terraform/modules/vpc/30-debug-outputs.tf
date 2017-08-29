/*
 * Module: VPC
 *
 * Outputs:
 *   -
 */

data "null_data_source" "debug_outputs" {

  count = "${var.enable_debug == "true" ? 1 : 0}"

  inputs = {
    deploy_environment = "${var.deploy_environment}"
    vpc_cidr_block = "${var.vpc_cidr_block}"
    vpc_base_cidr = "${var.vpc_cidr_block}"
    enable_classiclink = "${var.enable_classiclink}"
    enable_dns_support = "${var.enable_dns_support}"
    enable_dns_hostnames = "${var.enable_dns_hostnames}"
    name_prefix = "${lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")}"
    base_aws_tags = "${format("%s|%s",
            join(",", keys(var.base_aws_tags)),
            join(",", values(var.base_aws_tags))
        )}"
  }
}

output "debug_config" {
  value = "${ data.null_data_source.debug_outputs.inputs}"
}