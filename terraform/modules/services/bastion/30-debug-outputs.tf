data "null_data_source" "debug_outputs" {

  count = "${var.enable_debug == "true" ? 1 : 0}"

  inputs = {

    # inputs-required
    aws_region = "${var.aws_region}"
    vpc_id = "${var.vpc_id}"
    vpc_shortname = "${var.vpc_shortname}"
    bastion_public_key = "${var.vpc_id}"
    bastion_subnets = "${var.bastion_subnets}"
    provisioner_username = "${var.provisioner_username}"
    provisioner_ssh_public_key = "${var.provisioner_ssh_public_key}"
    monitoring_security_group = "${var.monitoring_security_group}"
    deploy_environment = "${var.deploy_environment}"

    # inputs-default
    lc_associate_public_ip_address = "${var.lc_associate_public_ip_address}"
    lc_ami_id = "${var.lc_ami_id}"
    lc_instance_type = "${var.lc_instance_type}"
    lc_iam_instance_profile = "${var.lc_iam_instance_profile}"
    lc_ebs_optimized = "${var.lc_ebs_optimized}"
    lc_root_block_device = "${var.lc_root_block_device}"

    asg_min_size = "${var.asg_min_size}"
    asg_max_size = "${var.asg_max_size}"
    asg_desired_capacity = "${var.asg_desired_capacity}"
    asg_health_check_type = "${var.asg_health_check_type}"
    asg_force_delete = "${var.asg_force_delete}"
    asg_termination_policies = "${var.asg_termination_policies}"
    asg_health_check_grace_period = "${var.asg_health_check_grace_period}"

    tag_monitoring = "On"

    # interpolated-defaults
    name_prefix = "${lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")}"
  }
}

output "debug_config" {
  value = "${ data.null_data_source.debug_outputs.inputs}"
}