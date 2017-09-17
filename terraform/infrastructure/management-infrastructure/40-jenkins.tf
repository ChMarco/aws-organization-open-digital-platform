module "jenkins" {
  source = "../../modules/services/jenkins"

  aws_region = "${var.aws_region}"
  vpc_id = "${lookup(module.vpc.vpc_outputs, "vpc_id")}"
  vpc_shortname = "${var.vpc_shortname}"

  jenkins_image_tag = "${var.jenkins_image_tag}"
  jenkins_public_key = "${var.jenkins_public_key}"
  jenkins_subnets = "${lookup(module.vpc.vpc_outputs, "public_subnet_ids")}"
  jenkins_elb_subnets = "${lookup(module.vpc.vpc_outputs, "dmz_subnet_ids")}"
  jenkins_ssh_bastion_access = "${lookup(module.bastion.bastion_outputs, "bastion_security_group_id")}"
  jenkins_web_whitelist = "${var.jenkins_web_whitelist}"

  monitoring_security_group = "${lookup(module.vpc.vpc_outputs, "vpc_monitoring_secuirty_group")}"
  deploy_environment = "${var.deploy_environment}"

  tag_resource_name = "${var.tag_jenkins_resource_name}"
  tag_project_name = "${var.tag_jenkins_project_name}"
  tag_environment = "${var.tag_jenkins_environment}"
  tag_cost_center = "${var.tag_jenkins_cost_center}"
  tag_service = "${var.tag_jenkins_service}"
  tag_app_operations_owner = "${var.tag_jenkins_app_operations_owner}"
  tag_system_owner = "${var.tag_jenkins_system_owner}"
  tag_budget_owner = "${var.tag_jenkins_budget_owner}"

}