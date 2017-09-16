//module "openvpn" {
//  source = "../../modules/services/openvpn"
//
//  aws_region = "${var.aws_region}"
//  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
//  vpc_cidr = "${var.vpc_cidr_block}"
//  vpc_shortname = "${var.vpc_shortname}"
//
//  openvpn_public_key = "${var.provisioner_ssh_public_key}"
//  openvpn_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
//
//  deploy_environment = "${var.deploy_environment}"
//
//  tag_resource_name = "${var.tag_openvpn_resource_name}"
//  tag_project_name = "${var.tag_openvpn_project_name}"
//  tag_environment = "${var.tag_openvpn_environment}"
//  tag_cost_center = "${var.tag_openvpn_cost_center}"
//  tag_service = "${var.tag_openvpn_service}"
//  tag_app_operations_owner = "${var.tag_openvpn_app_operations_owner}"
//  tag_system_owner = "${var.tag_openvpn_system_owner}"
//  tag_budget_owner = "${var.tag_openvpn_budget_owner}"
//
//}