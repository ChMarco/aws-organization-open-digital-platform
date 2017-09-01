module "bitbucket" {
  source = "../../modules/services/bitbucket"

  aws_region = "${var.aws_region}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
  vpc_shortname = "${var.vpc_shortname}"
  bitbucket_public_key = "${var.bitbucket_public_key}"
  bitbucket_subnets = "${lookup(module.vpc.vpc_outputs, "public_subnet_ids")}"
  bitbucket_elb_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
  bitbucket_rds_subnets = "${lookup(module.vpc.vpc_outputs, "private_subnet_ids")}"
  bitbucket_ssh_bastion_access = "${lookup(module.bastion.bastion_outputs, "bastion_security_group_id")}"
  bitbucket_web_whitelist = "${var.bitbucket_web_whitelist}"
  deploy_environment = "${var.deploy_environment}"

}