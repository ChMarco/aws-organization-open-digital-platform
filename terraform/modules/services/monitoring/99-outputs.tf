data "null_data_source" "outputs" {
  inputs {
    monitoring_key_pair_name = "${aws_key_pair.monitoring_key_pair.key_name}"
    monitoring_security_group_id = "${aws_security_group.monitoring_security_group.id}"
    monitoring_grafana_elb_security_group_id = "${aws_security_group.monitoring_grafana_elb_security_group.id}"
    monitoring_efs_security_group_id = "${aws_security_group.monitoring_efs_security_group.id}"
    monitoring_efs_id = "${aws_efs_file_system.monitoring_efs.id}"
    monitoring_efs_mount_target_ids = "${join(",", aws_efs_mount_target.monitoring_efs_mount_target.*.id)}"
    monitoring_grafana_elb_dns_name = "${aws_elb.monitoring_grafana_elb.dns_name}"
    monitoring_role_arn = "${aws_iam_role.monitoring_role.arn}"
    monitoring_iam_instance_profile_id = "${aws_iam_instance_profile.monitoring_instance_profile.id}"
    monitoring_iam_instance_profile_arn = "${aws_iam_instance_profile.monitoring_instance_profile.arn}"
    monitoring_iam_instance_profile_name = "${aws_iam_instance_profile.monitoring_instance_profile.name}"
    monitoring_iam_policy_id = "${aws_iam_policy.monitoring_iam_policy.id}"
    monitoring_iam_policy_arn = "${aws_iam_policy.monitoring_iam_policy.arn}"
    monitoring_iam_policy_name = "${aws_iam_policy.monitoring_iam_policy.name}"
    monitoring_launch_configuration_id = "${aws_launch_configuration.monitoring_launch_configuration.id}"
    monitoring_launch_configuration_name = "${aws_launch_configuration.monitoring_launch_configuration.name}"
    monitoring_autoscaling_group_id = "${aws_autoscaling_group.monitoring_asg.id}"
    monitoring_autoscaling_group_arn = "${aws_autoscaling_group.monitoring_asg.arn}"
    monitoring_ecs_cluster_id = "${aws_ecs_cluster.monitoring_ecs_cluster.id}"
    monitoring_cadvisor_ecs_task_definition_arn = "${aws_ecs_task_definition.monitoring_cadvisor_ecs_task.arn}"
    monitoring_node_exporter_ecs_task_definition_arn = "${aws_ecs_task_definition.monitoring_node_exporter_ecs_task.arn}"
    monitoring_grafana_ecs_task_definition_arn = "${aws_ecs_task_definition.monitoring_grafana_ecs_task.arn}"
    monitoring_prometheus_ecs_task_definition_arn = "${aws_ecs_task_definition.monitoring_prometheus_ecs_task.arn}"
    monitoring_cadvisor_ecs_service_id = "${aws_ecs_service.monitoring_cadvisor_ecs_service.id}"
    monitoring_node_exporter_ecs_service = "${aws_ecs_service.monitoring_node_exporter_ecs_service.id}"
    monitoring_grafana_ecs_service = "${aws_ecs_service.monitoring_grafana_ecs_service.id}"
    monitoring_prometheus_ecs_service = "${aws_ecs_service.monitoring_prometheus_ecs_service.id}"
  }
}

output "monitoring_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}