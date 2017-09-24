module "bastion" {
  source = "../../modules/services/bastion"

  aws_region = "${var.aws_region}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
  vpc_shortname = "${var.vpc_shortname}"
  bastion_public_key = "${var.management_keypair}"
  bastion_ssh_whitelist = "${var.ssh_web_whitelist}"
  bastion_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
  provisioner_ssh_public_key = "${var.management_keypair}"

  monitoring_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_monitoring_security_group")}"
  deploy_environment = "${var.deploy_environment}"

  tag_project_name = "${var.tag_project_name}"
  tag_environment = "${var.tag_environment}"
  tag_cost_center = "${var.tag_cost_center}"
  tag_app_operations_owner = "${var.tag_app_operations_owner}"
  tag_system_owner = "${var.tag_system_owner}"
  tag_budget_owner = "${var.tag_budget_owner}"

}