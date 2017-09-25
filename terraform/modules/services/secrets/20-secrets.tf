/*
 * Module: Secrets Management
 *
 * Components:
 *   - vault_key_pair
 *   - vault_security_group
 *   - vault_efs_security_group
 *   - vault_efs
 *   - vault_efs_mount_target
 *   - vault_assume_role_policy_document
 *   - vault_iam_policy_document
 *   - vault_role
 *   - vault_instance_profile
 *   - vault_iam_policy
 *   - vault_role_iam_policy_attachment
 *   - vault_launch_configuration
 *   - vault_asg
 *   - vault_ecs_cluster
 *   - vault_ecs_task
 *   - vault_ecs_service
 */

resource "aws_key_pair" "vault_key_pair" {

  key_name = "${format("%s_vault_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  public_key = "${var.vault_public_key}"
}

resource "aws_security_group" "vault_security_group" {

  name = "${format("%s_vault_ec2_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Vault Instances Security Group",
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
      "${var.vault_ssh_bastion_access}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_vault_ec2",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_security_group" "vault_efs_security_group" {

  name = "${format("%s_vault_efs_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Vault efs Security Group",
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
      "${aws_security_group.vault_security_group.id}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_vault_efs",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_efs_file_system" "vault_efs" {

  performance_mode = "generalPurpose"

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_vault_efs_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_efs_mount_target" "vault_efs_mount_target" {

  count = "${length(data.aws_availability_zones.available.names)}"

  file_system_id = "${aws_efs_file_system.vault_efs.id}"
  subnet_id = "${element(split(",", var.vault_subnets), count.index)}"
  security_groups = [
    "${aws_security_group.vault_efs_security_group.id}"
  ]
}

data "aws_iam_policy_document" "vault_assume_role_policy_document" {

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

data "aws_iam_policy_document" "vault_iam_policy_document" {

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

resource "aws_iam_role" "vault_role" {

  name = "${format("%s_%s_vault_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  assume_role_policy = "${data.aws_iam_policy_document.vault_assume_role_policy_document.json}"
}

resource "aws_iam_instance_profile" "vault_instance_profile" {

  name = "${format("%s_%s_vault_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  role = "${aws_iam_role.vault_role.name}"
}

resource "aws_iam_policy" "vault_iam_policy" {

  name = "${format("%s_%s_vault_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  policy = "${data.aws_iam_policy_document.vault_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "vault_role_iam_policy_attachment" {

  role = "${aws_iam_role.vault_role.name}"
  policy_arn = "${aws_iam_policy.vault_iam_policy.arn}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user-data.tpl")}"

  vars {
    efs_id = "${aws_efs_file_system.vault_efs.id}"
    consul_acl_master_token_uuid = "04AEB3B2-45BD-4FCE-9137-ED54BD44023B"
    ecs_cluster_name = "${format("%s_vault_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_launch_configuration" "vault_launch_configuration" {

  name_prefix = "${format("%s_vault_%s_",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  image_id = "${coalesce(
        var.lc_ami_id,
        lookup(var.vault_ami, var.aws_region)
    )}"
  instance_type = "${var.lc_instance_type}"
  associate_public_ip_address = "${var.lc_associate_public_ip_address}"
  key_name = "${aws_key_pair.vault_key_pair.key_name}"
  security_groups = [
    "${aws_security_group.vault_security_group.id}",
    "${var.monitoring_security_group}",
    "${var.secrets_security_group}",
    "${var.discovery_security_group}"
  ]

  iam_instance_profile = "${coalesce(
        var.lc_iam_instance_profile,
        aws_iam_instance_profile.vault_instance_profile.name
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

resource "aws_autoscaling_group" "vault_asg" {

  vpc_zone_identifier = [
    "${split(",", var.vault_subnets)}"
  ]
  name = "${format("%s_vault_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  desired_capacity = "${var.asg_desired_capacity}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type = "${var.asg_health_check_type}"
  force_delete = "${var.asg_force_delete}"
  launch_configuration = "${aws_launch_configuration.vault_launch_configuration.name}"
  termination_policies = [
    "${var.asg_termination_policies}"
  ]

  tag {
    key = "Name"
    value = "${format("%s_vault_%s",
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

resource "aws_ecs_cluster" "vault_ecs_cluster" {
  name = "${format("%s_vault_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
}

data "template_file" "vault_task_template" {
  template = "${file("${path.module}/templates/secrets_vault_server.json.tpl")}"
}

resource "aws_ecs_task_definition" "vault_ecs_task" {
  family = "secrets"
  container_definitions = "${data.template_file.vault_task_template.rendered}"

  volume {
    name = "vault_policies"
    host_path = "/mnt/efs/vault/policies"
  }
}

resource "aws_ecs_service" "vault_ecs_service" {
  name = "${format("%s_vault_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${aws_ecs_cluster.vault_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.vault_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  placement_constraints {
    type = "distinctInstance"
  }

  depends_on = [
    "aws_autoscaling_group.vault_asg"
  ]
}