module "bastion" {
  source = "../../modules/services/bastion"

  aws_region = "${var.aws_region}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
  vpc_shortname = "${var.vpc_shortname}"
  bastion_public_key = "${var.bastion_public_key}"
  bastion_ssh_whitelist = "${var.bastion_ssh_whitelist}"
  bastion_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
  provisioner_ssh_public_key = "${var.provisioner_ssh_public_key}"
  deploy_environment = "${var.deploy_environment}"

}