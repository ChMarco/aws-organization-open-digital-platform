module "vpc" {
  source = "../../modules/networking/vpc"

  aws_region = "${var.aws_region}"
  vpc_description = "${var.vpc_description}-${var.deploy_environment}"
  vpc_shortname = "${var.vpc_shortname}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
  dmz_subnet_cidr_blocks = "${var.dmz_subnet_cidr_blocks}"
  public_subnet_cidr_blocks = "${var.public_subnet_cidr_blocks}"
  private_subnet_cidr_blocks = "${var.private_subnet_cidr_blocks}"
  deploy_environment = "${var.deploy_environment}"

  tag_project_name = "${var.tag_project_name}"
  tag_environment = "${var.tag_environment}"
  tag_cost_center = "${var.tag_cost_center}"
  tag_app_operations_owner = "${var.tag_app_operations_owner}"
  tag_system_owner = "${var.tag_system_owner}"
  tag_budget_owner = "${var.tag_budget_owner}"

}

module "route53_private_zone" {
  source = "../../modules/networking/route53/private_zone"

  name = "${var.private_zone_name}"
  comment = "${var.private_zone_comment}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"

  tag_project_name = "${var.tag_project_name}"
  tag_environment = "${var.tag_environment}"
  tag_cost_center = "${var.tag_cost_center}"
  tag_app_operations_owner = "${var.tag_app_operations_owner}"
  tag_system_owner = "${var.tag_system_owner}"
  tag_budget_owner = "${var.tag_budget_owner}"

}