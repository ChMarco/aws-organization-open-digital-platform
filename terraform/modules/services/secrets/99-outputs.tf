data "null_data_source" "outputs" {
  inputs {
    vault_key_pair_name = "${aws_key_pair.vault_key_pair.key_name}"
    vault_security_group_id = "${aws_security_group.vault_security_group.id}"
    vault_efs_security_group_id = "${aws_security_group.vault_efs_security_group.id}"
    vault_efs_id = "${aws_efs_file_system.vault_efs.id}"
    vault_efs_mount_target_ids = "${join(",", aws_efs_mount_target.vault_efs_mount_target.*.id)}"
    vault_role_arn = "${aws_iam_role.vault_role.arn}"
    vault_iam_instance_profile_id = "${aws_iam_instance_profile.vault_instance_profile.id}"
    vault_iam_instance_profile_arn = "${aws_iam_instance_profile.vault_instance_profile.arn}"
    vault_iam_instance_profile_name = "${aws_iam_instance_profile.vault_instance_profile.name}"
    vault_iam_policy_id = "${aws_iam_policy.vault_iam_policy.id}"
    vault_iam_policy_arn = "${aws_iam_policy.vault_iam_policy.arn}"
    vault_iam_policy_name = "${aws_iam_policy.vault_iam_policy.name}"
    vault_launch_configuration_id = "${aws_launch_configuration.vault_launch_configuration.id}"
    vault_launch_configuration_name = "${aws_launch_configuration.vault_launch_configuration.name}"
    vault_autoscaling_group_id = "${aws_autoscaling_group.vault_asg.id}"
    vault_autoscaling_group_arn = "${aws_autoscaling_group.vault_asg.arn}"
    vault_ecs_cluster_id = "${aws_ecs_cluster.vault_ecs_cluster.id}"
    vault_vault_ecs_task_arn = "${aws_ecs_task_definition.vault_ecs_task.arn}"
    vault_vault_ecs_service_id = "${aws_ecs_service.vault_ecs_service.id}"
  }
}

output "vault_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}