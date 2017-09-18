/*
 * Module: Monitoring
 *
 * Components:
 *   - monitoring_key_pair
 *   - monitoring_security_group
 *   - monitoring_internal_elb_security_group
 *   - monitoring_grafana_elb_security_group
 *   - monitoring_efs_security_group
 *   - monitoring_efs
 *   - monitoring_efs_mount_target
 *   - monitoring_grafana_elb
 *   - monitoring_internal_elb
 *   - monitoring_assume_role_policy_document
 *   - monitoring_iam_policy_document
 *   - monitoring_role
 *   - monitoring_instance_profile
 *   - monitoring_iam_policy
 *   - monitoring_role_iam_policy_attachment
 *   - monitoring_launch_configuration
 *   - monitoring_asg
 *   - monitoring_cadvisor_ecs_task
 *   - monitoring_node_exporter_ecs_task
 *   - monitoring_prometheus_ecs_task
 *   - monitoring_alertmanager_ecs_task
 *   - monitoring_grafana_ecs_task
 *   - monitoring_ecs_cluster
 *   - monitoring_cadvisor_ecs_service
 *   - monitoring_node_exporter_ecs_service
 *   - monitoring_prometheus_ecs_service
 *   - monitoring_alertmanager_ecs_service
 *   - monitoring_grafana_ecs_service
 */

resource "aws_key_pair" "monitoring_key_pair" {

  key_name = "${format("%s_monitoring_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  public_key = "${var.monitoring_public_key}"
}

resource "aws_security_group" "monitoring_security_group" {

  name = "${format("%s_monitoring_ec2_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Monitoring Instances Security Group",
        title(lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"))
    )}"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = "true"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = "true"
  }

  ingress {
    from_port = 22
    protocol = "6"
    to_port = 22
    security_groups = [
      "${var.monitoring_ssh_bastion_access}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_monitoring_ec2",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_security_group" "monitoring_internal_elb_security_group" {

  name = "${format("%s_monitoring_elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Monitoring elb Security Group",
        title(lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"))
    )}"

  vpc_id = "${var.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 9090
    to_port = 9090
    protocol = "6"
    security_groups = [
      "${aws_security_group.monitoring_security_group.id}"
    ]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "6"
    security_groups = [
      "${aws_security_group.monitoring_security_group.id}"
    ]
  }

  ingress {
    from_port = 9100
    to_port = 9100
    protocol = "6"
    security_groups = [
      "${aws_security_group.monitoring_security_group.id}"
    ]
  }

  ingress {
    from_port = 9093
    to_port = 9093
    protocol = "6"
    security_groups = [
      "${aws_security_group.monitoring_security_group.id}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_monitoring_elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"

  lifecycle {
    create_before_destroy = "true"
  }

}

resource "aws_security_group" "monitoring_grafana_elb_security_group" {

  name = "${format("%s_monitoring_grafana_elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Monitoring grafana elb Security Group",
        title(lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"))
    )}"

  vpc_id = "${var.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 3000
    protocol = "6"
    to_port = 3000
    cidr_blocks = [
      "${compact(
              split(",",
                  replace(
                      join(",", values(var.monitoring_web_whitelist)),
                      "0.0.0.0/0",
                      ""
                  )
              )
          )}"
    ]
  }

  ingress {
    from_port = 80
    protocol = "6"
    to_port = 80
    cidr_blocks = [
      "${compact(
              split(",",
                  replace(
                      join(",", values(var.monitoring_web_whitelist)),
                      "0.0.0.0/0",
                      ""
                  )
              )
          )}"
    ]
  }

  ingress {
    from_port = 443
    protocol = "6"
    to_port = 443
    cidr_blocks = [
      "${compact(
              split(",",
                  replace(
                      join(",", values(var.monitoring_web_whitelist)),
                      "0.0.0.0/0",
                      ""
                  )
              )
          )}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_monitoring_grafana_elb_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"

  lifecycle {
    create_before_destroy = "true"
  }

}

resource "aws_security_group" "monitoring_efs_security_group" {

  name = "${format("%s_monitoring_efs_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Monitoring efs Security Group",
        title(lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"))
    )}"

  vpc_id = "${var.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "6"
    security_groups = [
      "${aws_security_group.monitoring_security_group.id}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_monitoring_efs",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_efs_file_system" "monitoring_efs" {

  performance_mode = "generalPurpose"

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_monitoring_efs_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_efs_mount_target" "monitoring_efs_mount_target" {

  count = "${length(data.aws_availability_zones.available.names)}"

  file_system_id = "${aws_efs_file_system.monitoring_efs.id}"
  subnet_id = "${element(split(",", var.monitoring_subnets), count.index)}"
  security_groups = [
    "${aws_security_group.monitoring_efs_security_group.id}"
  ]
}

resource "aws_elb" "monitoring_grafana_elb" {

  name = "${format("%s-grafana-%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  subnets = [
    "${split(",", var.monitoring_elb_subnets)}"
  ]

  security_groups = [
    "${aws_security_group.monitoring_security_group.id}",
    "${aws_security_group.monitoring_grafana_elb_security_group.id}"
  ]

  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  listener {
    instance_port = "3000"
    instance_protocol = "tcp"
    lb_port = "3000"
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 5
    target = "TCP:3000"
    interval = "30"
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s-grafana-proxy-%s",
                  lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                  lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_elb" "monitoring_internal_elb" {

  name = "${format("%s-monitoring-%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  subnets = [
    "${split(",", var.monitoring_subnets)}",
  ]

  security_groups = [
    "${aws_security_group.monitoring_security_group.id}",
    "${aws_security_group.monitoring_internal_elb_security_group.id}"
  ]

  internal = "true"
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  listener {
    instance_port = "9090"
    instance_protocol = "tcp"
    lb_port = "9090"
    lb_protocol = "tcp"
  }

  listener {
    instance_port = "9100"
    instance_protocol = "tcp"
    lb_port = "9100"
    lb_protocol = "tcp"
  }

  listener {
    instance_port = "8080"
    instance_protocol = "tcp"
    lb_port = "8080"
    lb_protocol = "tcp"
  }

  listener {
    instance_port = "9093"
    instance_protocol = "tcp"
    lb_port = "9093"
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 5
    target = "TCP:9090"
    interval = "30"
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s-monitoring-%s",
                  lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                  lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

data "aws_iam_policy_document" "monitoring_assume_role_policy_document" {

  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "monitoring_iam_policy_document" {

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags",
      "ec2:Describe*",
      "autoscaling:Describe*",
      "iam:PassRole",
      "s3:*"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:AssociateAddress",
      "ec2:ReplaceRoute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecs:StartTask",
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:RegisterTaskDefinition",
      "ecs:RunTask",
      "ecs:StopTask",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeContainerInstances",
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "monitoring_role" {

  name = "${format("%s_%s_monitoring_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  assume_role_policy = "${data.aws_iam_policy_document.monitoring_assume_role_policy_document.json}"
}

resource "aws_iam_instance_profile" "monitoring_instance_profile" {

  name = "${format("%s_%s_monitoring_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  role = "${aws_iam_role.monitoring_role.name}"
}

resource "aws_iam_policy" "monitoring_iam_policy" {

  name = "${format("%s_%s_monitoring_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  policy = "${data.aws_iam_policy_document.monitoring_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "monitoring_role_iam_policy_attachment" {

  role = "${aws_iam_role.monitoring_role.name}"
  policy_arn = "${aws_iam_policy.monitoring_iam_policy.arn}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user-data.tpl")}"

  vars {
    efs_id = "${aws_efs_file_system.monitoring_efs.id}"
    monitoring_elb_dns_name = "${aws_elb.monitoring_internal_elb.dns_name}"
    ecs_cluster_name = "${format("%s_monitoring_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_launch_configuration" "monitoring_launch_configuration" {

  name_prefix = "${format("%s_monitoring_%s_",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  image_id = "${coalesce(
        var.lc_ami_id,
        lookup(var.monitoring_ami, var.aws_region)
    )}"
  instance_type = "${var.lc_instance_type}"
  associate_public_ip_address = "${var.lc_associate_public_ip_address}"
  key_name = "${aws_key_pair.monitoring_key_pair.key_name}"
  security_groups = [
    "${aws_security_group.monitoring_security_group.id}",
    "${var.monitoring_security_group}",
    "${var.discovery_security_group}",
  ]

  iam_instance_profile = "${coalesce(
        var.lc_iam_instance_profile,
        aws_iam_instance_profile.monitoring_instance_profile.name
    )}"

  lifecycle {
    create_before_destroy = true
  }

  ebs_optimized = "${var.lc_ebs_optimized}"
  root_block_device {
    volume_type = "${element(split(":", var.lc_root_block_device), 0)}"
    volume_size = "${element(split(":", var.lc_root_block_device), 1)}"
    delete_on_termination = "${element(split(":", var.lc_root_block_device), 2)}"
  }
  user_data = "${data.template_file.user_data.rendered}"
}

resource "aws_autoscaling_group" "monitoring_asg" {

  vpc_zone_identifier = [
    "${split(",", var.monitoring_subnets)}"
  ]
  name = "${format("%s_monitoring_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  desired_capacity = "${var.asg_desired_capacity}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type = "${var.asg_health_check_type}"
  force_delete = "${var.asg_force_delete}"
  launch_configuration = "${aws_launch_configuration.monitoring_launch_configuration.name}"
  termination_policies = [
    "${var.asg_termination_policies}"
  ]

  tag {
    key = "Name"
    value = "${format("%s_monitoring_%s",
          lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
          lookup(data.null_data_source.tag_defaults.inputs, "Environment")
      )}"
    propagate_at_launch = true
  }
  tag {
    key = "Resource_Name"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "Resource_Name")}"
    propagate_at_launch = true
  }
  tag {
    key = "Project_Name"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "Project_Name")}"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "Environment")}"
    propagate_at_launch = true
  }
  tag {
    key = "Cost_Center"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "Cost_Center")}"
    propagate_at_launch = true
  }
  tag {
    key = "Service"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "Service")}"
    propagate_at_launch = true
  }
  tag {
    key = "App_Operations_Owner"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "App_Operations_Owner")}"
    propagate_at_launch = true
  }
  tag {
    key = "System_Owner"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "System_Owner")}"
    propagate_at_launch = true
  }
  tag {
    key = "Budget_Owner"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "Budget_Owner")}"
    propagate_at_launch = true
  }
  tag {
    key = "Created_By"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "Created_By")}"
    propagate_at_launch = true
  }

}

data "template_file" "monitoring_cadvisor_task_template" {
  template = "${file("${path.module}/templates/monitoring_cadvisor.json.tpl")}"
}

data "template_file" "monitoring_node_exporter_task_template" {
  template = "${file("${path.module}/templates/monitoring_node_exporter.json.tpl")}"
}

data "template_file" "monitoring_prometheus_task_template" {
  template = "${file("${path.module}/templates/monitoring_prometheus.json.tpl")}"

  vars {
    monitoring_elb_dns_name = "${aws_elb.monitoring_internal_elb.dns_name}"
  }
}

data "template_file" "monitoring_alertmanager_task_template" {
  template = "${file("${path.module}/templates/monitoring_alertmanager.json.tpl")}"
}

data "template_file" "monitoring_grafana_task_template" {
  template = "${file("${path.module}/templates/monitoring_grafana.json.tpl")}"
}

resource "aws_ecs_task_definition" "monitoring_cadvisor_ecs_task" {
  family = "monitoring"
  container_definitions = "${data.template_file.monitoring_cadvisor_task_template.rendered}"

  volume {
    name = "root"
    host_path = "/"
  }

  volume {
    name = "var_run"
    host_path = "/var/run"
  }

  volume {
    name = "sys"
    host_path = "/sys"
  }

  volume {
    name = "var_lib_docker"
    host_path = "/var/lib/docker/"
  }

  volume {
    name = "cgroup"
    host_path = "/cgroup"
  }
}

resource "aws_ecs_task_definition" "monitoring_node_exporter_ecs_task" {
  family = "monitoring"
  container_definitions = "${data.template_file.monitoring_node_exporter_task_template.rendered}"

  network_mode = "host"
}

resource "aws_ecs_task_definition" "monitoring_prometheus_ecs_task" {
  family = "monitoring"
  container_definitions = "${data.template_file.monitoring_prometheus_task_template.rendered}"

  volume {
    name = "prometheus_data"
    host_path = "/var/opt/prometheus"
  }

  volume {
    name = "efs-monitoring"
    host_path = "/mnt/efs"
  }
}

resource "aws_ecs_task_definition" "monitoring_alertmanager_ecs_task" {
  family = "monitoring"
  container_definitions = "${data.template_file.monitoring_alertmanager_task_template.rendered}"

  volume {
    name = "alertmanager_data"
    host_path = "/var/opt/alertmanager"
  }

  volume {
    name = "efs-monitoring"
    host_path = "/mnt/efs"
  }
}

resource "aws_ecs_task_definition" "monitoring_grafana_ecs_task" {
  family = "monitoring"
  container_definitions = "${data.template_file.monitoring_grafana_task_template.rendered}"

  volume {
    name = "efs-monitoring"
    host_path = "/mnt/efs"
  }
}

resource "aws_ecs_cluster" "monitoring_ecs_cluster" {
  name = "${format("%s_monitoring_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
}

resource "aws_ecs_service" "monitoring_cadvisor_ecs_service" {
  name = "${format("%s_monitoring_cadvisor_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.monitoring_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.monitoring_cadvisor_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.monitoring_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.monitoring_internal_elb.name}"
    container_name = "cadvisor"
    container_port = 8080
  }

  depends_on = [
    "aws_autoscaling_group.monitoring_asg"
  ]
}

resource "aws_ecs_service" "monitoring_node_exporter_ecs_service" {
  name = "${format("%s_monitoring_node_exporter_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.monitoring_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.monitoring_node_exporter_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.monitoring_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.monitoring_internal_elb.name}"
    container_name = "nodeexporter"
    container_port = 9100
  }

  depends_on = [
    "aws_autoscaling_group.monitoring_asg"
  ]
}

resource "aws_ecs_service" "monitoring_prometheus_ecs_service" {
  name = "${format("%s_monitoring_prometheus_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.monitoring_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.monitoring_prometheus_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.monitoring_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.monitoring_internal_elb.name}"
    container_name = "prometheus"
    container_port = 9090
  }

  depends_on = [
    "aws_autoscaling_group.monitoring_asg"
  ]
}

resource "aws_ecs_service" "monitoring_alertmanager_ecs_service" {
  name = "${format("%s_monitoring_alertmanager_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.monitoring_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.monitoring_alertmanager_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.monitoring_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.monitoring_internal_elb.name}"
    container_name = "alertmanager"
    container_port = 9093
  }

  depends_on = [
    "aws_autoscaling_group.monitoring_asg"
  ]
}

resource "aws_ecs_service" "monitoring_grafana_ecs_service" {
  name = "${format("%s_monitoring_grafana_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.monitoring_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.monitoring_grafana_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.monitoring_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.monitoring_grafana_elb.name}"
    container_name = "grafana"
    container_port = 3000
  }

  depends_on = [
    "aws_autoscaling_group.monitoring_asg"
  ]
}

# Discovery

## Agent

data "template_file" "discovery_consul_agent_task_template" {
  template = "${file("${path.module}/templates/discovery_consul_agent.json.tpl")}"

  vars {
    bootstrap_expect = "${var.service_desired_count}"
    consul_dc = "dc01"
    join = "${format("%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  }
}

resource "aws_ecs_task_definition" "discovery_consul_agent_ecs_task" {
  family = "discovery"
  container_definitions = "${data.template_file.discovery_consul_agent_task_template.rendered}"

  task_role_arn = "${aws_iam_role.monitoring_role.arn}"

  network_mode = "host"

  volume {
    host_path = "/etc/consul.d"
    name = "consul_config"
  }

  volume {
    host_path = "/var/lib/consul"
    name = "consul_data"
  }
}

resource "aws_ecs_service" "discovery_consul_agent_ecs_service" {
  name = "${format("%s_discovery_consul_agent_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.monitoring_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.discovery_consul_agent_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  placement_constraints {
    type = "distinctInstance"
  }

  depends_on = [
    "aws_autoscaling_group.monitoring_asg"
  ]
}

## Registrator

data "template_file" "discovery_consul_registrator_task_template" {
  template = "${file("${path.module}/templates/discovery_consul_registrator.json.tpl")}"
}

resource "aws_ecs_task_definition" "discovery_consul_registrator_ecs_task" {
  family = "discovery"
  container_definitions = "${data.template_file.discovery_consul_registrator_task_template.rendered}"

  task_role_arn = "${aws_iam_role.monitoring_role.arn}"

  network_mode = "host"

  volume {
    host_path = "/opt/consul-registrator/bin"
    name = "consul_registrator_bin"
  }

  volume {
    host_path = "/var/run/docker.sock"
    name = "docker_socket"
  }
}

resource "aws_ecs_service" "discovery_consul_registrator_ecs_service" {
  name = "${format("%s_discovery_consul_registrator_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.monitoring_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.discovery_consul_registrator_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  placement_constraints {
    type = "distinctInstance"
  }

  depends_on = [
    "aws_autoscaling_group.monitoring_asg"
  ]
}