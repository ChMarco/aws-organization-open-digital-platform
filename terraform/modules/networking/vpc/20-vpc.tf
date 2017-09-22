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
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_support = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names, count.index)
            )
        )
    )}"
}

#--------------------------------------------------------------
# Default Security Groups
#--------------------------------------------------------------

# Monitoring

resource "aws_security_group" "monitoring_security_group" {

  name = "${format("%s_monitoring_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Monitoring Security Group - Default",
        title(lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"))
    )}"
  vpc_id = "${aws_vpc.vpc.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 9100
    to_port = 9100
    protocol = "6"
    self = "true"
  }

  ingress {
    from_port = 9191
    to_port = 9191
    protocol = "6"
    self = "true"
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_monitoring_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

# Discovery

resource "aws_security_group" "discovery_security_group" {

  name = "${format("%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Discovery Security Group - Default",
        title(lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"))
    )}"
  vpc_id = "${aws_vpc.vpc.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 8300
    to_port = 8300
    protocol = "6"
    cidr_blocks = [
      "${var.vpc_cidr_block}"
    ]
  }

  ingress {
    from_port = 8301
    to_port = 8301
    protocol = "6"
    cidr_blocks = [
      "${var.vpc_cidr_block}"
    ]
  }

  ingress {
    from_port = 8301
    to_port = 8301
    protocol = "17"
    cidr_blocks = [
      "${var.vpc_cidr_block}"
    ]
  }

  ingress {
    from_port = 8302
    to_port = 8302
    protocol = "6"
    cidr_blocks = [
      "${var.vpc_cidr_block}"
    ]
  }

  ingress {
    from_port = 8302
    to_port = 8302
    protocol = "17"
    cidr_blocks = [
      "${var.vpc_cidr_block}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
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
        data.null_data_source.tag_defaults.inputs,
        map(
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
        data.null_data_source.tag_defaults.inputs,
        map(
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
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_dmz_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names , count.index)
            ),
        "Network", "DMZ"
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
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_public_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names , count.index)
            ),
            "Network", "Public"
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
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_private_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names , count.index)
            ),
        "Network", "Private"
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
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_dmz_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names, count.index)
            ),
            "Network", "DMZ"
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
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_public_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names, count.index)
            ),
            "Network", "Public"
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
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_private_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                element(data.aws_availability_zones.available.names, count.index)
            ),
            "Network", "Private"
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
