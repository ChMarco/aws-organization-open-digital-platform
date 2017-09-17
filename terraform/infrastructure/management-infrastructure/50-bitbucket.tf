//module "bitbucket" {
//  source = "../../modules/services/bitbucket"
//
//  aws_region = "${var.aws_region}"
//  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
//  vpc_shortname = "${var.vpc_shortname}"
//  bitbucket_public_key = "${var.bitbucket_public_key}"
//  bitbucket_subnets = "${lookup(module.vpc.vpc_outputs, "public_subnet_ids")}"
//  bitbucket_elb_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
//  bitbucket_rds_subnets = "${lookup(module.vpc.vpc_outputs, "private_subnet_ids")}"
//  bitbucket_ssh_bastion_access = "${lookup(module.bastion.bastion_outputs, "bastion_security_group_id")}"
//  bitbucket_web_whitelist = "${var.bitbucket_web_whitelist}"
//
//  monitoring_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_monitoring_secuirty_group")}"
//  deploy_environment = "${var.deploy_environment}"
//
//  tag_resource_name = "${var.tag_bitbucket_resource_name}"
//  tag_project_name = "${var.tag_bitbucket_project_name}"
//  tag_environment = "${var.tag_bitbucket_environment}"
//  tag_cost_center = "${var.tag_bitbucket_cost_center}"
//  tag_service = "${var.tag_bitbucket_service}"
//  tag_app_operations_owner = "${var.tag_bitbucket_app_operations_owner}"
//  tag_system_owner = "${var.tag_bitbucket_system_owner}"
//  tag_budget_owner = "${var.tag_bitbucket_budget_owner}"
//
//}