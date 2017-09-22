data "null_data_source" "vpc_outputs" {
  inputs {
    vpc_id = "${aws_vpc.vpc.id}"
    aws_region = "${var.aws_region}"
    vpc_cidr_block = "${aws_vpc.vpc.cidr_block}"
    igw_id = "${aws_internet_gateway.vpc_igw.id}"
    vgw_id = "${aws_vpn_gateway.vpn_gw.id}"
    vpc_monitoring_security_group = "${aws_security_group.monitoring_security_group.id}"
    vpc_discovery_security_group = "${aws_security_group.discovery_security_group.id}"
  }
}
