data "null_data_source" "debug_outputs" {

  count = "${var.enable_debug == "true" ? 1 : 0}"

  inputs = {

    # inputs-required
    aws_region = "${var.aws_region}"
    vpc_description = "${var.vpc_description}"
    vpc_shortname = "${var.vpc_shortname}"
    vpc_cidr_block = "${var.vpc_cidr_block}"
    dmz_subnet_cidr_blocks = "${var.dmz_subnet_cidr_blocks}"
    public_subnet_cidr_blocks = "${var.public_subnet_cidr_blocks}"
    private_subnet_cidr_blocks = "${var.private_subnet_cidr_blocks}"
    deploy_environment = "${var.deploy_environment}"

    # inputs-default
    enable_debug = "${var.enable_debug}"
    enable_dns_support = "${var.enable_dns_support}"
    enable_dns_hostnames = "${var.enable_dns_hostnames}"

    # interpolated-defaults
    name_prefix = "${lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")}"

  }
}

output "debug_config" {
  value = "${ data.null_data_source.debug_outputs.inputs}"
}