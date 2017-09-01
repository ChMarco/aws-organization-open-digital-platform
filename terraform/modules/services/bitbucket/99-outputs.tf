data "null_data_source" "outputs" {
  inputs {
    bitbucket_key_pair_name = "${aws_key_pair.bitbucket_key_pair.key_name}"
    bitbucket_security_group_id = "${aws_security_group.bitbucket_security_group.id}"
    bitbucket_efs_security_group_id = "${aws_security_group.bitbucket_efs_security_group.id}"
    bitbucket_rds_security_group_id = "${aws_security_group.bitbucket_rds_security_group.id}"
    bitbucket_efs_id = "${aws_efs_file_system.bitbucket_efs.id}"
    bitbucket_efs_mount_target_ids = "${join(",", aws_efs_mount_target.bitbucket_efs_mount_target.*.id)}"
    bitbucket_elb_dns_name = "${aws_elb.bitbucket_elb.dns_name}"
    bitbucket_rds_arn = "${aws_db_instance.bitbucket_rds.arn}"
    bitbucket_rds_address = "${aws_db_instance.bitbucket_rds.address}"
    bitbucket_role_arn = "${aws_iam_role.bitbucket_role.arn}"
    bitbucket_iam_instance_profile_id = "${aws_iam_instance_profile.bitbucket_instance_profile.id}"
    bitbucket_iam_instance_profile_arn = "${aws_iam_instance_profile.bitbucket_instance_profile.arn}"
    bitbucket_iam_instance_profile_name = "${aws_iam_instance_profile.bitbucket_instance_profile.name}"
    bitbucket_iam_policy_id = "${aws_iam_policy.bitbucket_iam_policy.id}"
    bitbucket_iam_policy_arn = "${aws_iam_policy.bitbucket_iam_policy.arn}"
    bitbucket_iam_policy_name = "${aws_iam_policy.bitbucket_iam_policy.name}"
    bitbucket_launch_configuration_id = "${aws_launch_configuration.bitbucket_launch_configuration.id}"
    bitbucket_launch_configuration_name = "${aws_launch_configuration.bitbucket_launch_configuration.name}"
    bitbucket_autoscaling_group_id = "${aws_autoscaling_group.bitbucket_asg.id}"
    bitbucket_autoscaling_group_arn = "${aws_autoscaling_group.bitbucket_asg.arn}"
    bitbucket_ecs_cluster_id = "${aws_ecs_cluster.bitbucket_ecs_cluster.id}"
    bitbucket_ecs_task_definition_arn = "${aws_ecs_task_definition.bitbucket_ecs_task.arn}"
    bitbucket_ecs_service_id = "${aws_ecs_service.bitbucket_ecs_service.id}"
  }
}

output "bitbucket_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}