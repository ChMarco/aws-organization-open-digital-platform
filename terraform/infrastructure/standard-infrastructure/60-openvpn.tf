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
//}