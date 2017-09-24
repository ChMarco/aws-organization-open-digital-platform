data "null_data_source" "debug_outputs" {

  count = "${var.enable_debug == "true" ? 1 : 0}"

  inputs = {

    # inputs-required
    mgmt_vpc_id = "${var.mgmt_vpc_id}"
    mgmt_vpc_cidr = "${var.mgmt_vpc_cidr}"
    mgmt_vpc_shortname = "${var.mgmt_vpc_shortname}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    vpc_shortname = "${var.vpc_shortname}"
    dmz_route_tables = "${var.dmz_route_tables}"
    public_route_tables = "${var.public_route_tables}"
    private_route_tables = "${var.private_route_tables}"
    deploy_environment = "${var.deploy_environment}"

    # inputs-default
    enable_debug = "${var.enable_debug}"
    networks = "${var.networks}"

    # interpolated-defaults
    name_prefix = "${lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")}"
  }
}

output "debug_config" {
  value = "${ data.null_data_source.debug_outputs.inputs}"
}