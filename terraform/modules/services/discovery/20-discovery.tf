/*
 * Module: Discovery
 *
 * Components:
 *   - discovery_key_pair
 *   - discovery_security_group
 *   - discovery_consul_alb_security_group
 *   - discovery_efs_security_group
 *   - discovery_efs
 *   - discovery_efs_mount_target
 *   - discovery_consul_alb
 *   - discovery_consul_alb_target_group
 *   - discovery_consul_alb_listener
 *   - discovery_consul_alb_listener_rule
 *   - discovery_assume_role_policy_document
 *   - discovery_iam_policy_document
 *   - discovery_role
 *   - discovery_instance_profile
 *   - discovery_iam_policy
 *   - discovery_role_iam_policy_attachment
 *   - discovery_launch_configuration
 *   - discovery_asg
 *   - discovery_ecs_cluster
 *   - discovery_consul_ecs_task
 *   - discovery_consul_ecs_service
 */

resource "aws_key_pair" "discovery_key_pair" {

  key_name = "${format("%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  public_key = "${var.discovery_public_key}"
}

resource "aws_security_group" "discovery_security_group" {

  name = "${format("%s_discovery_ec2_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Discovery Instances Security Group",
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
      "${var.discovery_ssh_bastion_access}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_discovery_ec2",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_security_group" "discovery_consul_alb_security_group" {

  name = "${format("%s_discovery_consul_elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Discovery consul elb Security Group",
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

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_discovery_consul_elb_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"

  lifecycle {
    create_before_destroy = "true"
  }

}

resource "aws_security_group_rule" "allow_web_access_http" {
  count = "${length(split(",", var.discovery_web_whitelist))}"

  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "6"
  cidr_blocks = [
    "${element(split(",", var.discovery_web_whitelist), count.index)}"
  ]
  security_group_id = "${aws_security_group.discovery_consul_alb_security_group.id}"
}

resource "aws_security_group_rule" "allow_web_access_https" {
  count = "${length(split(",", var.discovery_web_whitelist))}"

  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "6"
  cidr_blocks = [
    "${element(split(",", var.discovery_web_whitelist), count.index)}"
  ]
  security_group_id = "${aws_security_group.discovery_consul_alb_security_group.id}"
}

resource "aws_security_group" "discovery_efs_security_group" {

  name = "${format("%s_discovery_efs_%s",
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
      "${aws_security_group.discovery_security_group.id}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_discovery_efs",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_efs_file_system" "discovery_efs" {

  performance_mode = "generalPurpose"

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_discovery_efs_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_efs_mount_target" "discovery_efs_mount_target" {

  count = "${length(data.aws_availability_zones.available.names)}"

  file_system_id = "${aws_efs_file_system.discovery_efs.id}"
  subnet_id = "${element(split(",", var.discovery_subnets), count.index)}"
  security_groups = [
    "${aws_security_group.discovery_efs_security_group.id}"
  ]
}

resource "aws_alb" "discovery_consul_alb" {
  name = "${format("%s-consul-%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  security_groups = [
    "${aws_security_group.discovery_security_group.id}",
    "${aws_security_group.discovery_consul_alb_security_group.id}"
  ]

  subnets = [
    "${split(",", var.discovery_elb_subnets)}"
  ]

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s-consul-%s",
                  lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                  lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_alb_target_group" "discovery_consul_alb_target_group" {

  name = "${format("%s-consul-albtg-%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  port = 8500
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  health_check {
    path = "/v1/agent/self"
    port = 8500
    protocol = "HTTP"
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s-consul-albtg-%s",
                  lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                  lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_alb_listener" "discovery_consul_alb_listener" {
  load_balancer_arn = "${aws_alb.discovery_consul_alb.arn}"
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.discovery_consul_alb_target_group.arn}"
    type = "forward"
  }
}

resource "aws_alb_listener_rule" "discovery_consul_alb_listener_rule" {

  listener_arn = "${aws_alb_listener.discovery_consul_alb_listener.arn}"
  priority = 100

  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.discovery_consul_alb_target_group.arn}"
  }

  condition {
    field = "path-pattern"
    values = [
      "/*"]
  }
}

data "aws_iam_policy_document" "discovery_assume_role_policy_document" {

  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com",
        "events.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "discovery_iam_policy_document" {

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

resource "aws_iam_role" "discovery_role" {

  name = "${format("%s_%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  assume_role_policy = "${data.aws_iam_policy_document.discovery_assume_role_policy_document.json}"
}

resource "aws_iam_instance_profile" "discovery_instance_profile" {

  name = "${format("%s_%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  role = "${aws_iam_role.discovery_role.name}"
}

resource "aws_iam_policy" "discovery_iam_policy" {

  name = "${format("%s_%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  policy = "${data.aws_iam_policy_document.discovery_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "discovery_role_iam_policy_attachment" {

  role = "${aws_iam_role.discovery_role.name}"
  policy_arn = "${aws_iam_policy.discovery_iam_policy.arn}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user-data.tpl")}"

  vars {
    efs_id = "${aws_efs_file_system.discovery_efs.id}"
    consul_dc = "${data.aws_caller_identity.current.account_id}-${var.aws_region}"
    consul_acl_master_token_uuid = "04AEB3B2-45BD-4FCE-9137-ED54BD44023B"
    ecs_cluster_name = "${format("%s_discovery_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_launch_configuration" "discovery_launch_configuration" {

  name_prefix = "${format("%s_discovery_%s_",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  image_id = "${coalesce(
        var.lc_ami_id,
        lookup(var.discovery_ami, var.aws_region)
    )}"
  instance_type = "${var.lc_instance_type}"
  associate_public_ip_address = "${var.lc_associate_public_ip_address}"
  key_name = "${aws_key_pair.discovery_key_pair.key_name}"
  security_groups = [
    "${aws_security_group.discovery_security_group.id}",
    "${var.discovery_security_group}",
    "${var.monitoring_security_group}"
  ]

  iam_instance_profile = "${coalesce(
        var.lc_iam_instance_profile,
        aws_iam_instance_profile.discovery_instance_profile.name
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

resource "aws_autoscaling_group" "discovery_asg" {

  vpc_zone_identifier = [
    "${split(",", var.discovery_subnets)}"
  ]
  name = "${format("%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  desired_capacity = "${var.asg_desired_capacity}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type = "${var.asg_health_check_type}"
  force_delete = "${var.asg_force_delete}"
  launch_configuration = "${aws_launch_configuration.discovery_launch_configuration.name}"
  termination_policies = [
    "${var.asg_termination_policies}"
  ]

  tag {
    key = "Name"
    value = "${format("%s_discovery_%s",
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
    key = "Monitoring"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "Monitoring")}"
    propagate_at_launch = true
  }
  tag {
    key = "Created_By"
    value = "${lookup(data.null_data_source.tag_defaults.inputs, "Created_By")}"
    propagate_at_launch = true
  }

}

resource "aws_ecs_cluster" "discovery_ecs_cluster" {
  name = "${format("%s_discovery_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
}

data "template_file" "discovery_consul_task_template" {
  template = "${file("${path.module}/templates/discovery_consul_server.json.tpl")}"

  vars {
    bootstrap_expect = "${var.service_desired_count}"
    consul_dc = "${data.aws_caller_identity.current.account_id}-${var.aws_region}"
    join = "${format("%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  }
}

data "template_file" "discovery_consul_agent_task_template" {
  template = "${file("${path.module}/templates/discovery_consul_agent.json.tpl")}"

  vars {
    bootstrap_expect = "${var.service_desired_count}"
    consul_dc = "${data.aws_caller_identity.current.account_id}-${var.aws_region}"
    join = "${format("%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  }
}

resource "aws_ecs_task_definition" "discovery_consul_agent_ecs_task" {
  family = "discovery-agent"
  container_definitions = "${data.template_file.discovery_consul_agent_task_template.rendered}"

  task_role_arn = "${aws_iam_role.discovery_role.arn}"

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

data "template_file" "discovery_consul_registrator_task_template" {
  template = "${file("${path.module}/templates/discovery_consul_registrator.json.tpl")}"
}

resource "aws_ecs_task_definition" "discovery_consul_registrator_ecs_task" {
  family = "discovery-agent"
  container_definitions = "${data.template_file.discovery_consul_registrator_task_template.rendered}"

  task_role_arn = "${aws_iam_role.discovery_role.arn}"

  network_mode = "host"

  volume {
    host_path = "/mnt/efs/consul/consul-registrator/bin"
    name = "consul_registrator_bin"
  }

  volume {
    host_path = "/var/run/docker.sock"
    name = "docker_socket"
  }
}

resource "aws_ecs_task_definition" "discovery_consul_ecs_task" {
  family = "discovery"
  container_definitions = "${data.template_file.discovery_consul_task_template.rendered}"

  network_mode = "host"

  volume {
    name = "consul_config"
    host_path = "/etc/consul.d"

  }

  volume {
    name = "consul_data"
    host_path = "/var/lib/consul"
  }
}

resource "aws_ecs_service" "discovery_consul_ecs_service" {
  name = "${format("%s_discovery_consul_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.discovery_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.discovery_consul_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.discovery_role.arn}"

  load_balancer {
    container_name = "consul-server"
    container_port = "8500"
    target_group_arn = "${aws_alb_target_group.discovery_consul_alb_target_group.arn}"
  }

  placement_constraints {
    type = "distinctInstance"
  }

  depends_on = [
    "aws_autoscaling_group.discovery_asg"
  ]
}