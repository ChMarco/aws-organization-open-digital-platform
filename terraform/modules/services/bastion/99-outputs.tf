data "null_data_source" "outputs" {
  inputs {
    bastion_eip_id = "${aws_eip.bastion_eip.id}"
    bastion_eip_public_ip = "${aws_eip.bastion_eip.public_ip}"
    bastion_key_pair_name = "${aws_key_pair.bastion_key_pair.key_name}"
    bastion_security_group_id = "${aws_security_group.bastion_security_group.id}"
    bastion_role_arn = "${aws_iam_role.bastion_role.arn}"
    bastion_iam_instance_profile_id = "${aws_iam_instance_profile.bastion_instance_profile.id}"
    bastion_iam_instance_profile_arn = "${aws_iam_instance_profile.bastion_instance_profile.arn}"
    bastion_iam_instance_profile_name = "${aws_iam_instance_profile.bastion_instance_profile.name}"
    bastion_iam_policy_id = "${aws_iam_policy.bastion_iam_policy.id}"
    bastion_iam_policy_arn = "${aws_iam_policy.bastion_iam_policy.arn}"
    bastion_iam_policy_name = "${aws_iam_policy.bastion_iam_policy.name}"
    bastion_launch_configuration_id = "${aws_launch_configuration.bastion_launch_configuration.id}"
    bastion_launch_configuration_name = "${aws_launch_configuration.bastion_launch_configuration.name}"
    bastion_autoscaling_group_id = "${aws_autoscaling_group.bastion_asg.id}"
    bastion_autoscaling_group_arn = "${aws_autoscaling_group.bastion_asg.arn}"
  }
}

output "bastion_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}