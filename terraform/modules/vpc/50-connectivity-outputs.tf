/*
 * Module: VPC
 *
 * Outputs
 *
 */

data "null_data_source" "connectivity_outputs" {
  inputs {
    igw_id = "${aws_internet_gateway.vpc_igw.id}"
    dmz_rt_id = "${join(",", aws_route_table.dmz_subnet_rt.*.id)}"
    dmz_subnet_ids = "${join(",", aws_subnet.dmz_subnet.*.id)}"
    dmz_subnet_cidr_blocks = "${join(",", aws_subnet.dmz_subnet.*.cidr_block)}"
    dmz_subnet_rta_ids = "${join(",", aws_route_table_association.dmz_subnet_rta.*.id)}"
    public_rt_id = "${join(",", aws_route_table.public_subnet_rt.*.id)}"
    public_subnet_ids = "${join(",", aws_subnet.public_subnet.*.id)}"
    public_subnet_cidr_blocks = "${join(",", aws_subnet.public_subnet.*.cidr_block)}"
    public_subnet_rta_ids = "${join(",", aws_route_table_association.public_subnet_rta.*.id)}"
    private_rt_id = "${join(",", aws_route_table.private_subnet_rt.*.id)}"
    private_subnet_ids = "${join(",", aws_subnet.private_subnet.*.id)}"
    private_subnet_cidr_blocks = "${join(",", aws_subnet.private_subnet.*.cidr_block)}"
    private_subnet_rta_ids = "${join(",", aws_route_table_association.private_subnet_rta.*.id)}"

    natgw_eip_ids = "${join(",", aws_eip.natgw_eip.*.id)}"
    natgw_eip_public_ips = "${join(",", aws_eip.natgw_eip.*.public_ip)}"

    natgw_ids = "${join(",", aws_nat_gateway.natgw.*.id)}"
    natgw_allocation_ids = "${join(",", aws_nat_gateway.natgw.*.allocation_id)}"
    natgw_subnet_ids = "${join(",", aws_nat_gateway.natgw.*.subnet_id)}"
    natgw_private_ips = "${join(",", aws_nat_gateway.natgw.*.private_ip)}"
    natgw_public_ips = "${join(",", aws_nat_gateway.natgw.*.public_ip)}"
  }
}
