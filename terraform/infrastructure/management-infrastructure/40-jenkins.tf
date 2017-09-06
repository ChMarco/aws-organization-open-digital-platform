module "jenkins" {
  source = "../../modules/services/jenkins"

  aws_region = "${var.aws_region}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
  vpc_shortname = "${var.vpc_shortname}"
  jenkins_public_key = "${var.jenkins_public_key}"
  jenkins_subnets = "${lookup(module.vpc.vpc_outputs, "public_subnet_ids")}"
  jenkins_elb_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
  jenkins_ssh_bastion_access = "${lookup(module.bastion.bastion_outputs, "bastion_security_group_id")}"
  jenkins_web_whitelist = "${var.jenkins_web_whitelist}"
  deploy_environment = "${var.deploy_environment}"

}