module "secrets" {
  source = "../../modules/services/secrets"

  aws_region = "${var.aws_region}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
  vpc_shortname = "${var.vpc_shortname}"
  vault_public_key = "${var.management_keypair}"
  vault_image_tag = "${var.vault_image_tag}"
  vault_subnets = "${lookup(module.vpc.vpc_outputs, "public_subnet_ids")}"
  vault_elb_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
  vault_ssh_bastion_access = "${lookup(module.bastion.bastion_outputs, "bastion_security_group_id")}"
  vault_web_whitelist = "${var.ssh_web_whitelist}"

  monitoring_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_monitoring_security_group")}"
  discovery_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_discovery_security_group")}"
  secrets_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_secrets_security_group")}"
  deploy_environment = "${var.deploy_environment}"

  tag_project_name = "${var.tag_project_name}"
  tag_environment = "${var.tag_environment}"
  tag_cost_center = "${var.tag_cost_center}"
  tag_app_operations_owner = "${var.tag_app_operations_owner}"
  tag_system_owner = "${var.tag_system_owner}"
  tag_budget_owner = "${var.tag_budget_owner}"

}
