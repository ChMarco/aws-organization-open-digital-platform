/*
 * Module: GoCD
 *
 * Components:
 *   - gocd_key_pair
 *   - gocd_security_group
 *   - gocd_proxy_elb_security_group
 *   - gocd_efs_security_group
 *   - gocd_efs
 *   - gocd_efs_mount_target
 *   - gocd_elb
 *   - gocd_proxy_elb
 *   - gocd_assume_role_policy_document
 *   - gocd_iam_policy_document
 *   - gocd_role
 *   - gocd_instance_profile
 *   - gocd_iam_policy
 *   - gocd_role_iam_policy_attachment
 *   - gocd_launch_configuration
 *   - gocd_asg
 *   - gocd_ecs_cluster
 *   - gocd_ecs_task
 *   - gocd_proxy_ecs_task
 *   - gocd_ecs_service
 *   - gocd_proxy_ecs_service
 */

resource "aws_key_pair" "gocd_key_pair" {

  key_name = "${format("%s_gocd_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  public_key = "${var.gocd_public_key}"
}

resource "aws_security_group" "gocd_security_group" {

  name = "${format("%s_gocd_ec2_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s gocd Instances Security Group",
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

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_gocd_ec2_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_security_group" "gocd_elb_security_group" {

  name = "${format("%s_gocd_elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s gocd elb Security Group",
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
    from_port = 50000
    to_port = 50000
    protocol = "6"
    security_groups = [
      "${aws_security_group.gocd_security_group.id}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_gocd_elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"

  lifecycle {
    create_before_destroy = "true"
  }

}

resource "aws_security_group_rule" "gocd_allow_all_self" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  self = true

  security_group_id = "${aws_security_group.gocd_security_group.id}"
}

resource "aws_security_group_rule" "gocd_allow_bastion_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "6"
  source_security_group_id = "${var.gocd_ssh_bastion_access}"

  security_group_id = "${aws_security_group.gocd_security_group.id}"
}

resource "aws_security_group_rule" "gocd_allow_gocd_slave" {
  type = "ingress"
  from_port = 50000
  to_port = 50000
  protocol = "6"
  source_security_group_id = "${aws_security_group.gocd_elb_security_group.id}"

  security_group_id = "${aws_security_group.gocd_security_group.id}"
}

resource "aws_security_group" "gocd_proxy_elb_security_group" {

  name = "${format("%s_gocd_proxy_elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s gocd proxy elb Security Group",
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
            "Name", format("%s_gocd_proxy_elb_%s",
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
  count = "${length(split(",", var.gocd_web_whitelist))}"

  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "6"
  cidr_blocks = [
    "${element(split(",", var.gocd_web_whitelist), count.index)}"
  ]
  security_group_id = "${aws_security_group.gocd_proxy_elb_security_group.id}"
}

resource "aws_security_group_rule" "allow_web_access_https" {
  count = "${length(split(",", var.gocd_web_whitelist))}"

  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "6"
  cidr_blocks = [
    "${element(split(",", var.gocd_web_whitelist), count.index)}"
  ]
  security_group_id = "${aws_security_group.gocd_proxy_elb_security_group.id}"
}

resource "aws_security_group" "gocd_efs_security_group" {

  name = "${format("%s_gocd_efs_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s gocd efs Security Group",
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
      "${aws_security_group.gocd_security_group.id}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_gocd_efs_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_efs_file_system" "gocd_efs" {

  performance_mode = "generalPurpose"

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_gocd_efs_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_efs_mount_target" "gocd_efs_mount_target" {

  count = "${length(data.aws_availability_zones.available.names)}"

  file_system_id = "${aws_efs_file_system.gocd_efs.id}"
  subnet_id = "${element(split(",", var.gocd_subnets), count.index)}"
  security_groups = [
    "${aws_security_group.gocd_efs_security_group.id}"
  ]
}

resource "aws_elb" "gocd_elb" {

  name = "${format("%s-gocd-%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  subnets = [
    "${split(",", var.gocd_subnets)}",
  ]

  security_groups = [
    "${aws_security_group.gocd_security_group.id}",
    "${aws_security_group.gocd_elb_security_group.id}"
  ]

  internal = "true"
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  listener {
    instance_port = "8080"
    instance_protocol = "tcp"
    lb_port = "80"
    lb_protocol = "tcp"
  }

  listener {
    instance_port = "50000"
    instance_protocol = "tcp"
    lb_port = "50000"
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 5
    target = "HTTP:8080/login"
    interval = "30"
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s-gocd-%s",
                  lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                  lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_elb" "gocd_proxy_elb" {

  name = "${format("%s-gocd-proxy-%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  subnets = [
    "${split(",", var.gocd_elb_subnets)}"
  ]

  security_groups = [
    "${aws_security_group.gocd_security_group.id}",
    "${aws_security_group.gocd_proxy_elb_security_group.id}"
  ]

  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  listener {
    instance_port = "80"
    instance_protocol = "tcp"
    lb_port = "80"
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 5
    target = "HTTP:80/login"
    interval = "30"
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s-gocd-proxy-%s",
                  lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                  lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

data "aws_iam_policy_document" "gocd_assume_role_policy_document" {

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

data "aws_iam_policy_document" "gocd_iam_policy_document" {

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

resource "aws_iam_role" "gocd_role" {

  name = "${format("%s_%s_gocd_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  assume_role_policy = "${data.aws_iam_policy_document.gocd_assume_role_policy_document.json}"
}

resource "aws_iam_instance_profile" "gocd_instance_profile" {

  name = "${format("%s_%s_gocd_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  role = "${aws_iam_role.gocd_role.name}"
}

resource "aws_iam_policy" "gocd_iam_policy" {

  name = "${format("%s_%s_gocd_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  policy = "${data.aws_iam_policy_document.gocd_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "gocd_role_iam_policy_attachment" {

  role = "${aws_iam_role.gocd_role.name}"
  policy_arn = "${aws_iam_policy.gocd_iam_policy.arn}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user-data.tpl")}"

  vars {
    efs_id = "${aws_efs_file_system.gocd_efs.id}"
    gocd_elb_dns_name = "${aws_elb.gocd_elb.dns_name}"
    consul_dc = "${data.aws_caller_identity.current.account_id}-${var.aws_region}"
    ecs_cluster_name = "${format("%s_gocd_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
    account_id = "${var.account_id}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_launch_configuration" "gocd_launch_configuration" {

  name_prefix = "${format("%s_gocd_%s_",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  image_id = "${coalesce(
        var.lc_ami_id,
        lookup(var.gocd_ami, var.aws_region)
    )}"
  instance_type = "${var.lc_instance_type}"
  associate_public_ip_address = "${var.lc_associate_public_ip_address}"
  key_name = "${aws_key_pair.gocd_key_pair.key_name}"
  security_groups = [
    "${aws_security_group.gocd_security_group.id}",
    "${var.monitoring_security_group}",
    "${var.secrets_security_group}",
    "${var.discovery_security_group}"
  ]

  iam_instance_profile = "${coalesce(
        var.lc_iam_instance_profile,
        aws_iam_instance_profile.gocd_instance_profile.name
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

resource "aws_autoscaling_group" "gocd_asg" {

  vpc_zone_identifier = [
    "${split(",", var.gocd_subnets)}"
  ]
  name = "${format("%s_gocd_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  desired_capacity = "${var.asg_desired_capacity}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type = "${var.asg_health_check_type}"
  force_delete = "${var.asg_force_delete}"
  launch_configuration = "${aws_launch_configuration.gocd_launch_configuration.name}"
  termination_policies = [
    "${var.asg_termination_policies}"
  ]

  tag {
    key = "Name"
    value = "${format("%s_gocd_%s",
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

data "template_file" "gocd_task_template" {
  template = "${file("${path.module}/templates/gocd.json.tpl")}"

  vars {
    gocd_image_tag = "${var.gocd_image_tag}"
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

data "template_file" "gocd_proxy_task_template" {
  template = "${file("${path.module}/templates/gocd_proxy.json.tpl")}"
}

resource "aws_ecs_cluster" "gocd_ecs_cluster" {
  name = "${format("%s_gocd_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
}

resource "aws_ecs_task_definition" "gocd_ecs_task" {
  family = "gocd"
  container_definitions = "${data.template_file.gocd_task_template.rendered}"

  volume {
    name = "gocd_data"
    host_path = "/mnt/efs/gocd"
  }
}

resource "aws_ecs_task_definition" "gocd_proxy_ecs_task" {
  family = "gocd_proxy"
  container_definitions = "${data.template_file.gocd_proxy_task_template.rendered}"

  volume {
    name = "nginx-conf"
    host_path = "/etc/nginx/nginx.conf"
  }
}

resource "aws_ecs_service" "gocd_ecs_service" {
  name = "${format("%s_gocd_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.gocd_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.gocd_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.gocd_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.gocd_elb.name}"
    container_name = "gocd"
    container_port = 8080
  }

  depends_on = [
    "aws_elb.gocd_elb",
    "aws_autoscaling_group.gocd_asg"
  ]
}

resource "aws_ecs_service" "gocd_proxy_ecs_service" {
  name = "${format("%s_gocd_proxy_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.gocd_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.gocd_proxy_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.gocd_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.gocd_proxy_elb.name}"
    container_name = "nginx"
    container_port = 80
  }

  depends_on = [
    "aws_elb.gocd_proxy_elb",
    "aws_autoscaling_group.gocd_asg"
  ]
}