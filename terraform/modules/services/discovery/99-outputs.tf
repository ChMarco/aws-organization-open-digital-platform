data "null_data_source" "outputs" {
  inputs {
    discovery_key_pair_name = "${aws_key_pair.discovery_key_pair.key_name}"
    discovery_security_group_id = "${aws_security_group.discovery_security_group.id}"
    discovery_consul_alb_security_group = "${aws_security_group.discovery_consul_alb_security_group.id}"
    discovery_efs_security_group_id = "${aws_security_group.discovery_efs_security_group.id}"
    discovery_efs_id = "${aws_efs_file_system.discovery_efs.id}"
    discovery_efs_mount_target_ids = "${join(",", aws_efs_mount_target.discovery_efs_mount_target.*.id)}"
    discovery_grafana_alb_dns_name = "${aws_alb.discovery_consul_alb.dns_name}"
    discovery_grafana_alb_target_group_arn = "${aws_alb_target_group.discovery_consul_alb_target_group.arn}"
    discovery_grafana_alb_listner_arn = "${aws_alb_listener.discovery_consul_alb_listener.arn}"
    discovery_role_arn = "${aws_iam_role.discovery_role.arn}"
    discovery_iam_instance_profile_id = "${aws_iam_instance_profile.discovery_instance_profile.id}"
    discovery_iam_instance_profile_arn = "${aws_iam_instance_profile.discovery_instance_profile.arn}"
    discovery_iam_instance_profile_name = "${aws_iam_instance_profile.discovery_instance_profile.name}"
    discovery_iam_policy_id = "${aws_iam_policy.discovery_iam_policy.id}"
    discovery_iam_policy_arn = "${aws_iam_policy.discovery_iam_policy.arn}"
    discovery_iam_policy_name = "${aws_iam_policy.discovery_iam_policy.name}"
    discovery_launch_configuration_id = "${aws_launch_configuration.discovery_launch_configuration.id}"
    discovery_launch_configuration_name = "${aws_launch_configuration.discovery_launch_configuration.name}"
    discovery_autoscaling_group_id = "${aws_autoscaling_group.discovery_asg.id}"
    discovery_autoscaling_group_arn = "${aws_autoscaling_group.discovery_asg.arn}"
    discovery_ecs_cluster_id = "${aws_ecs_cluster.discovery_ecs_cluster.id}"
    discovery_consul_ecs_task_arn = "${aws_ecs_task_definition.discovery_consul_ecs_task.arn}"
    discovery_consul_ecs_service_id = "${aws_ecs_service.discovery_consul_ecs_service.id}"
  }
}

output "discovery_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}