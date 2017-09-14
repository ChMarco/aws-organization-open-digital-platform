module "vpc" {
  source = "../../modules/vpc"

  aws_region = "${var.aws_region}"
  vpc_description = "${var.vpc_description}-${var.deploy_environment}"
  vpc_shortname = "${var.vpc_shortname}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
  dmz_subnet_cidr_blocks = "${var.dmz_subnet_cidr_blocks}"
  public_subnet_cidr_blocks = "${var.public_subnet_cidr_blocks}"
  private_subnet_cidr_blocks = "${var.private_subnet_cidr_blocks}"
  deploy_environment = "${var.deploy_environment}"

  tag_resource_name = "${var.tag_resource_name}"
  tag_project_name = "${var.tag_project_name}"
  tag_environment = "${var.tag_environment}"
  tag_cost_center = "${var.tag_cost_center}"
  tag_tier = "${var.tag_tier}"
  tag_app_operations_owner = "${var.tag_app_operations_owner}"
  tag_system_owner = "${var.tag_system_owner}"
  tag_budget_owner = "${var.tag_budget_owner}"

}

//module "vpc_peering" {
//  source = "../../modules/vpc-peering"
//
//  mgmt_vpc_id = "${var.mgmt_vpc_id}"
//  mgmt_vpc_cidr = "${var.mgmt_vpc_cidr}"
//  mgmt_vpc_shortname = "${var.mgmt_vpc_shortname}"
//
//  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
//  vpc_cidr = "${var.vpc_cidr_block}"
//  vpc_shortname = "${var.vpc_shortname}"
//
//  dmz_route_tables = "${lookup(module.vpc.vpc_outputs, "dmz_rt_id")}"
//  public_route_tables = "${lookup(module.vpc.vpc_outputs, "public_rt_id")}"
//  private_route_tables = "${lookup(module.vpc.vpc_outputs, "private_rt_id")}"
//
//  deploy_environment = "${var.deploy_environment}"
//
//  tag_resource_name = "${var.tag_resource_name}"
//  tag_project_name = "${var.tag_project_name}"
//  tag_environment = "${var.tag_environment}"
//  tag_cost_center = "${var.tag_cost_center}"
//  tag_tier = "${var.tag_tier}"
//  tag_app_operations_owner = "${var.tag_app_operations_owner}"
//  tag_system_owner = "${var.tag_system_owner}"
//  tag_budget_owner = "${var.tag_budget_owner}"
//}