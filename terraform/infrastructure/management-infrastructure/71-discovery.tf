module "discovery" {
  source = "../../modules/services/discovery"

  aws_region = "${var.aws_region}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
  vpc_shortname = "${var.vpc_shortname}"
  discovery_public_key = "${var.discovery_public_key}"
  discovery_subnets = "${lookup(module.vpc.vpc_outputs, "public_subnet_ids")}"
  discovery_elb_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
  discovery_ssh_bastion_access = "${lookup(module.bastion.bastion_outputs, "bastion_security_group_id")}"
  discovery_web_whitelist = "${var.discovery_web_whitelist}"

  monitoring_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_monitoring_secuirty_group")}"
  discovery_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_discovery_secuirty_group")}"
  deploy_environment = "${var.deploy_environment}"

  tag_resource_name = "${var.tag_discovery_resource_name}"
  tag_project_name = "${var.tag_discovery_project_name}"
  tag_environment = "${var.tag_discovery_environment}"
  tag_cost_center = "${var.tag_discovery_cost_center}"
  tag_service = "${var.tag_discovery_service}"
  tag_app_operations_owner = "${var.tag_discovery_app_operations_owner}"
  tag_system_owner = "${var.tag_discovery_system_owner}"
  tag_budget_owner = "${var.tag_discovery_budget_owner}"

}
