//module "secrets" {
//  source = "../../modules/services/secrets"
//
//  aws_region = "${var.aws_region}"
//  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
//  vpc_shortname = "${var.vpc_shortname}"
//  secrets_public_key = "${var.secrets_public_key}"
//  secrets_subnets = "${lookup(module.vpc.vpc_outputs, "public_subnet_ids")}"
//  secrets_elb_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
//  secrets_ssh_bastion_access = "${lookup(module.bastion.bastion_outputs, "bastion_security_group_id")}"
//  secrets_web_whitelist = "${var.secrets_web_whitelist}"
//
//  monitoring_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_monitoring_security_group")}"
//  discovery_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_discovery_security_group")}"
//  deploy_environment = "${var.deploy_environment}"
//
//  tag_resource_name = "${var.tag_secrets_resource_name}"
//  tag_project_name = "${var.tag_secrets_project_name}"
//  tag_environment = "${var.tag_secrets_environment}"
//  tag_cost_center = "${var.tag_secrets_cost_center}"
//  tag_service = "${var.tag_secrets_service}"
//  tag_app_operations_owner = "${var.tag_secrets_app_operations_owner}"
//  tag_system_owner = "${var.tag_secrets_system_owner}"
//  tag_budget_owner = "${var.tag_secrets_budget_owner}"
//
//}
