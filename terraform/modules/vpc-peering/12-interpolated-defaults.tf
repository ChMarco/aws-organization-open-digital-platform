data "null_data_source" "vpc_defaults" {
  inputs = {
    name_prefix = "${format("%s",
            var.vpc_shortname
        )}"
  }
}

data "aws_subnet_ids" "mgmt_subnets" {

  count = "${length(split(",", var.networks))}"
  vpc_id = "${var.mgmt_vpc_id}"

  tags {
    Network = "${element(split(",", var.networks), count.index)}"
  }
}

data "aws_route_table" "mgmt_dmz_route_tables" {

  count = "${length(split(",", var.networks))}"
  subnet_id = "${element(data.aws_subnet_ids.mgmt_subnets.0.ids, count.index)}"

}

data "aws_route_table" "mgmt_private_route_tables" {

  count = "${length(split(",", var.networks))}"
  subnet_id = "${element(data.aws_subnet_ids.mgmt_subnets.1.ids, count.index)}"

}

data "aws_route_table" "mgmt_public_route_tables" {

  count = "${length(split(",", var.networks))}"
  subnet_id = "${element(data.aws_subnet_ids.mgmt_subnets.2.ids, count.index)}"

}