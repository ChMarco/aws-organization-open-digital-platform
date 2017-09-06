//module "artifactory" {
//  source = "../../modules/services/artifactory"
//
//  aws_region = "${var.aws_region}"
//  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
//  vpc_shortname = "${var.vpc_shortname}"
//  artifactory_public_key = "${var.artifactory_public_key}"
//  artifactory_subnets = "${lookup(module.vpc.vpc_outputs, "public_subnet_ids")}"
//  artifactory_elb_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
//  artifactory_rds_subnets = "${lookup(module.vpc.vpc_outputs, "private_subnet_ids")}"
//  artifactory_ssh_bastion_access = "${lookup(module.bastion.bastion_outputs, "bastion_security_group_id")}"
//  artifactory_web_whitelist = "${var.artifactory_web_whitelist}"
//  deploy_environment = "${var.deploy_environment}"
//
//}