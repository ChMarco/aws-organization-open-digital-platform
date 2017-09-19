data "null_data_source" "outputs" {
  inputs {
    jenkins_key_pair_name = "${aws_key_pair.jenkins_key_pair.key_name}"
    jenkins_security_group_id = "${aws_security_group.jenkins_security_group.id}"
    jenkins_proxy_elb_security_group_id = "${aws_security_group.jenkins_proxy_elb_security_group.id}"
    jenkins_efs_security_group_id = "${aws_security_group.jenkins_efs_security_group.id}"
    jenkins_efs_id = "${aws_efs_file_system.jenkins_efs.id}"
    jenkins_efs_mount_target_ids = "${join(",", aws_efs_mount_target.jenkins_efs_mount_target.*.id)}"
    jenkins_elb_dns_name = "${aws_elb.jenkins_elb.dns_name}"
    jenkins_proxy_elb_dns_name = "${aws_elb.jenkins_proxy_elb.dns_name}"
    jenkins_role_arn = "${aws_iam_role.jenkins_role.arn}"
    jenkins_iam_instance_profile_id = "${aws_iam_instance_profile.jenkins_instance_profile.id}"
    jenkins_iam_instance_profile_arn = "${aws_iam_instance_profile.jenkins_instance_profile.arn}"
    jenkins_iam_instance_profile_name = "${aws_iam_instance_profile.jenkins_instance_profile.name}"
    jenkins_iam_policy_id = "${aws_iam_policy.jenkins_iam_policy.id}"
    jenkins_iam_policy_arn = "${aws_iam_policy.jenkins_iam_policy.arn}"
    jenkins_iam_policy_name = "${aws_iam_policy.jenkins_iam_policy.name}"
    jenkins_launch_configuration_id = "${aws_launch_configuration.jenkins_launch_configuration.id}"
    jenkins_launch_configuration_name = "${aws_launch_configuration.jenkins_launch_configuration.name}"
    jenkins_autoscaling_group_id = "${aws_autoscaling_group.jenkins_asg.id}"
    jenkins_autoscaling_group_arn = "${aws_autoscaling_group.jenkins_asg.arn}"
    jenkins_ecs_cluster_id = "${aws_ecs_cluster.jenkins_ecs_cluster.id}"
    jenkins_ecs_task_definition_arn = "${aws_ecs_task_definition.jenkins_ecs_task.arn}"
    jenkins_proxy_ecs_task_definition_arn = "${aws_ecs_task_definition.jenkins_proxy_ecs_task.arn}"
    jenkins_ecs_service_id = "${aws_ecs_service.jenkins_ecs_service.id}"
    jenkins_proxy_ecs_service = "${aws_ecs_service.jenkins_proxy_ecs_service.id}"
  }
}

output "jenkins_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs,
        module.monitoring_agents.monitoring_agents_outputs,
        module.discovery_agents.discovery_agents_outputs
    )}"
}