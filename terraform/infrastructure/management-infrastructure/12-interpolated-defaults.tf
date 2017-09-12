data "aws_caller_identity" "current" {}

data "aws_subnet_ids" "mgmt_subnets" {

  count = "${length(split(",", var.networks))}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"

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

output "mgmt_dmz_subnets" {
  value = "${data.aws_subnet_ids.mgmt_subnets.0.ids}"
}

output "mgmt_private_subnets" {
  value = "${data.aws_subnet_ids.mgmt_subnets.1.ids}"
}

output "mgmt_public_subnets" {
  value = "${data.aws_subnet_ids.mgmt_subnets.2.ids}"
}

output "mgmt_dmz_route_tables" {
  value = "${data.aws_route_table.mgmt_dmz_route_tables.*.route_table_id}"
}

output "mgmt_public_route_tables" {
  value = "${data.aws_route_table.mgmt_private_route_tables.*.route_table_id}"
}

output "mgmt_private_route_tables" {
  value = "${data.aws_route_table.mgmt_public_route_tables.*.route_table_id}"
}