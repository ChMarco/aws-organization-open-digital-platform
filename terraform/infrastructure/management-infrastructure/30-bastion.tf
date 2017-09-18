module "bastion" {
  source = "../../modules/services/bastion"

  aws_region = "${var.aws_region}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
  vpc_shortname = "${var.vpc_shortname}"
  bastion_public_key = "${var.bastion_public_key}"
  bastion_ssh_whitelist = "${var.bastion_ssh_whitelist}"
  bastion_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
  provisioner_ssh_public_key = "${var.provisioner_ssh_public_key}"

  monitoring_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_monitoring_security_group")}"
  deploy_environment = "${var.deploy_environment}"

  tag_resource_name = "${var.tag_bastion_resource_name}"
  tag_project_name = "${var.tag_bastion_project_name}"
  tag_environment = "${var.tag_bastion_environment}"
  tag_cost_center = "${var.tag_bastion_cost_center}"
  tag_service = "${var.tag_bastion_service}"
  tag_app_operations_owner = "${var.tag_bastion_app_operations_owner}"
  tag_system_owner = "${var.tag_bastion_system_owner}"
  tag_budget_owner = "${var.tag_bastion_budget_owner}"

}