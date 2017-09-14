/*
 * Module: VPC Peering
 *
 * Components:
 *   - VPC Peering
 *   - VPC Peering Routes
 */

#--------------------------------------------------------------
# VPC Peering
#--------------------------------------------------------------

resource "aws_vpc_peering_connection" "vpc_peering_connection" {
  peer_vpc_id = "${var.mgmt_vpc_id}"
  vpc_id = "${var.vpc_id}"
  auto_accept = true

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_%sVPC Peering",
                var.vpc_shortname,
                var.mgmt_vpc_shortname
            )
        )
    )}"
}

#--------------------------------------------------------------
# VPC Peering Route Management --> Standard
#--------------------------------------------------------------

resource "aws_route" "mgmt_to_standard_dmz" {

  count = "${length(data.aws_availability_zones.available.names)}"

  route_table_id = "${element(data.aws_route_table.mgmt_dmz_route_tables.0.route_table_id, count.index)}"
  destination_cidr_block = "${var.vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}

resource "aws_route" "mgmt_to_standard_public" {

  count = "${length(data.aws_availability_zones.available.names)}"

  route_table_id = "${element(data.aws_route_table.mgmt_public_route_tables.1.route_table_id, count.index)}"
  destination_cidr_block = "${var.vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}

resource "aws_route" "mgmt_to_standard_private" {

  count = "${length(data.aws_availability_zones.available.names)}"

  route_table_id = "${element(data.aws_route_table.mgmt_private_route_tables.2.route_table_id, count.index)}"
  destination_cidr_block = "${var.vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}

#--------------------------------------------------------------
# VPC Peering Route Standard --> Management
#--------------------------------------------------------------

resource "aws_route" "standard_to_mgmt_dmz" {

  count = "${length(data.aws_availability_zones.available.names)}"

  route_table_id = "${element(split(",", var.dmz_route_tables), count.index)}"
  destination_cidr_block = "${var.mgmt_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}

resource "aws_route" "standard_to_mgmt_public" {

  count = "${length(data.aws_availability_zones.available.names)}"

  route_table_id = "${element(split(",", var.public_route_tables), count.index)}"
  destination_cidr_block = "${var.mgmt_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}

resource "aws_route" "standard_to_mgmt_private" {

  count = "${length(data.aws_availability_zones.available.names)}"

  route_table_id = "${element(split(",", var.private_route_tables), count.index)}"
  destination_cidr_block = "${var.mgmt_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}