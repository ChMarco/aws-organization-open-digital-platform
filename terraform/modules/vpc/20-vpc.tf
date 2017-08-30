/*
 * Module: VPC
 *
 * Components:
 *   - VPC
 *   - Internet Gateway
 *   - VPN Gateway
 *   - Subnets
 *   - Route Tables
 *   - Routes
 *   - VPC Endpoints
 *   - NAT Gateway & EIP
 */

#--------------------------------------------------------------
# VPC
#--------------------------------------------------------------

resource "aws_vpc" "vpc" {
  enable_classiclink = "${var.enable_classiclink}"
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_support = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

#--------------------------------------------------------------
# Connectivity
#--------------------------------------------------------------

# Internet Gateway

resource "aws_internet_gateway" "vpc_igw" {

  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_igw",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

# VPN Gateway

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_vgw",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

# Subnets

## DMZ (VPN)
resource "aws_subnet" "dmz_subnet" {

  count = "${length(data.aws_availability_zones.available.names)}"

  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${format("%s", element(data.aws_availability_zones.available.names, count.index))}"
  cidr_block = "${element(split(",", var.dmz_subnet_cidr_blocks), count.index)}"

  map_public_ip_on_launch = "true"
  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_dmz_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names , count.index)
            )
        )
    )}"
}

## Public
resource "aws_subnet" "public_subnet" {

  count = "${length(data.aws_availability_zones.available.names)}"

  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${format("%s", element(data.aws_availability_zones.available.names, count.index))}"
  cidr_block = "${element(split(",", var.public_subnet_cidr_blocks), count.index)}"

  map_public_ip_on_launch = "false"
  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_public_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names , count.index)
            )
        )
    )}"
}

## Private
resource "aws_subnet" "private_subnet" {

  count = "${length(data.aws_availability_zones.available.names)}"

  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${format("%s", element(data.aws_availability_zones.available.names, count.index))}"
  cidr_block = "${element(split(",", var.private_subnet_cidr_blocks), count.index)}"

  map_public_ip_on_launch = "false"
  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_private_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names , count.index)
            )
        )
    )}"
}

# Route Tables

## DMZ (VPN)
resource "aws_route_table" "dmz_subnet_rt" {

  vpc_id = "${aws_vpc.vpc.id}"
  propagating_vgws = [
    "${aws_vpn_gateway.vpn_gw.id}"
  ]

  count = "${length(data.aws_availability_zones.available.names)}"

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_dmz_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names, count.index)
            )
        )
    )}"
}

resource "aws_route_table_association" "dmz_subnet_rta" {
  subnet_id = "${element(aws_subnet.dmz_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.dmz_subnet_rt.*.id, count.index)}"

  count = "${length(data.aws_availability_zones.available.names)}"
}

## Public
resource "aws_route_table" "public_subnet_rt" {

  vpc_id = "${aws_vpc.vpc.id}"
  propagating_vgws = [
    "${aws_vpn_gateway.vpn_gw.id}"
  ]

  count = "${length(data.aws_availability_zones.available.names)}"

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_public_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names, count.index)
            )
        )
    )}"
}

resource "aws_route_table_association" "public_subnet_rta" {
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public_subnet_rt.*.id, count.index)}"
  count = "${length(data.aws_availability_zones.available.names)}"
}

## Private
resource "aws_route_table" "private_subnet_rt" {

  vpc_id = "${aws_vpc.vpc.id}"
  propagating_vgws = [
    "${aws_vpn_gateway.vpn_gw.id}"
  ]

  count = "${length(data.aws_availability_zones.available.names)}"

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_private_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names, count.index)
            )
        )
    )}"
}

resource "aws_route_table_association" "private_subnet_rta" {
  subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_subnet_rt.*.id, count.index)}"
  count = "${length(data.aws_availability_zones.available.names)}"
}

# Routes

resource "aws_route" "dmz_egress" {
  route_table_id = "${element(aws_route_table.dmz_subnet_rt.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.vpc_igw.id}"

  count = "${length(data.aws_availability_zones.available.names)}"

  depends_on = [
    "aws_route_table.dmz_subnet_rt"
  ]
}

resource "aws_route" "public_egress" {

  count = "${length(data.aws_availability_zones.available.names)}"

  route_table_id = "${element(aws_route_table.public_subnet_rt.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
//
  depends_on = [
    "aws_route_table.public_subnet_rt"
  ]
}

resource "aws_route" "private_egress" {
  route_table_id = "${element(aws_route_table.private_subnet_rt.*.id, count.index)}"
  nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"

  count = "${length(data.aws_availability_zones.available.names)}"

  depends_on = [
    "aws_route_table.public_subnet_rt"
  ]
}

#--------------------------------------------------------------
# NAT Gateway & EIP
#--------------------------------------------------------------

resource "aws_eip" "natgw_eip" {
  vpc = true

  count = "${length(data.aws_availability_zones.available.names)}"
}

resource "aws_nat_gateway" "natgw" {
  subnet_id = "${element(aws_subnet.dmz_subnet.*.id, count.index)}"
  allocation_id = "${element(aws_eip.natgw_eip.*.id, count.index)}"

  count = "${length(data.aws_availability_zones.available.names)}"
  depends_on = [
    "aws_internet_gateway.vpc_igw"
  ]
}

#--------------------------------------------------------------
# VPC Endpoints
#--------------------------------------------------------------

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = "${aws_vpc.vpc.id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3_endpoint.id}"
  route_table_id = "${element(aws_route_table.private_subnet_rt.*.id, count.index)}"

  count = "${length(data.aws_availability_zones.available.names)}"
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id = "${aws_vpc.vpc.id}"
  service_name = "${data.aws_vpc_endpoint_service.dynamodb.service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
  vpc_endpoint_id = "${aws_vpc_endpoint.dynamodb_endpoint.id}"
  route_table_id = "${element(aws_route_table.private_subnet_rt.*.id, count.index)}"

  count = "${length(data.aws_availability_zones.available.names)}"
}
