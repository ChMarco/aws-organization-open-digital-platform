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

}