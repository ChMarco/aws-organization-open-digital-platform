/*
 * Module: BitBucket
 *
 * Components:
 *   - bitbucket_key_pair
 *   - bitbucket_security_group
 *   - bitbucket_elb_security_group
 *   - bitbucket_rds_security_group
 *   - bitbucket_efs_security_group
 *   - bitbucket_efs
 *   - bitbucket_efs_mount_target
 *   - bitbucket_elb
 *   - bitbucket_assume_role_policy_document
 *   - bitbucket_iam_policy_document
 *   - bitbucket_role
 *   - bitbucket_instance_profile
 *   - bitbucket_iam_policy
 *   - bitbucket_role_iam_policy_attachment
 *   - bitbucket_launch_configuration
 *   - bitbucket_asg
 *   - bitbucket_rds
 *   - bitbucket_ecs_cluster
 *   - bitbucket_ecs_task
 *   - bitbucket_ecs_service
 */

resource "aws_key_pair" "bitbucket_key_pair" {

  key_name = "${format("%s_bitbucket_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  public_key = "${var.bitbucket_public_key}"
}

resource "aws_security_group" "bitbucket_security_group" {

  name = "${format("%s_bitbucket_ec2_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s BitBucket Instances Security Group",
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
      "${var.bitbucket_ssh_bastion_access}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_bitbucket_ec2",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_security_group" "bitbucket_elb_security_group" {

  name = "${format("%s_bitbucket_elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s BitBucket elb Security Group",
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
    from_port = 80
    protocol = "6"
    to_port = 80
    cidr_blocks = [
      "${compact(
              split(",",
                  replace(
                      join(",", values(var.bitbucket_web_whitelist)),
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
                      join(",", values(var.bitbucket_web_whitelist)),
                      "0.0.0.0/0",
                      ""
                  )
              )
          )}"
    ]
  }

  ingress {
    from_port = 50000
    protocol = "6"
    to_port = 50000
    cidr_blocks = [
      "${compact(
              split(",",
                  replace(
                      join(",", values(var.bitbucket_web_whitelist)),
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
            "Name", format("%s_bitbucket_elb",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"

}

resource "aws_security_group" "bitbucket_efs_security_group" {

  name = "${format("%s_bitbucket_efs_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s BitBucket efs Security Group",
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
      "${aws_security_group.bitbucket_security_group.id}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_bitbucket_efs",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_security_group" "bitbucket_rds_security_group" {

  name = "${format("%s_bitbucket_rds_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s BitBucket rds Security Group",
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
    from_port = 5432
    to_port = 5432
    protocol = "6"
    security_groups = [
      "${aws_security_group.bitbucket_security_group.id}"
    ]
  }

  ingress {
    from_port = 5432
    protocol = "6"
    to_port = 5432
    security_groups = [
      "${var.bitbucket_ssh_bastion_access}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_bitbucket_rds",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_efs_file_system" "bitbucket_efs" {

  performance_mode = "generalPurpose"

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_bitbucket_efs_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_efs_mount_target" "bitbucket_efs_mount_target" {

  count = "${length(split(",", var.bitbucket_subnets))}"

  file_system_id = "${aws_efs_file_system.bitbucket_efs.id}"
  subnet_id = "${element(split(",", var.bitbucket_subnets), count.index)}"
  security_groups = [
    "${aws_security_group.bitbucket_efs_security_group.id}"
  ]
}

resource "aws_elb" "bitbucket_elb" {

  name = "${format("%s-bitbucket-elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  subnets = [
    "${split(",", var.bitbucket_elb_subnets)}"
  ]

  security_groups = [
    "${aws_security_group.bitbucket_security_group.id}",
    "${aws_security_group.bitbucket_elb_security_group.id}"
  ]

  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  listener {
    instance_port = "7990"
    instance_protocol = "tcp"
    lb_port = "80"
    lb_protocol = "tcp"
  }

  listener {
    instance_port = "7999"
    instance_protocol = "tcp"
    lb_port = "7999"
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 5
    target = "HTTP:7990/status"
    interval = "30"
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s-bitbucket-%s",
                  lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                  lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_db_subnet_group" "bitbucket_rds_subnet_group" {

  name = "${format("%s-bitbucket-rds-sg_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s BitBucket efs Subnet Group",
        title(lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"))
    )}"

  subnet_ids = [
    "${split(",", var.bitbucket_rds_subnets)}"
  ]

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_bitbucket_rds",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_db_instance" "bitbucket_rds" {

  identifier = "${format("%s-bitbucket-rds_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  allocated_storage = "${var.rds_allocated_storage}"
  multi_az = "${var.rds_is_multi_az}"
  storage_type = "${var.rds_storage_type}"
  engine = "${var.rds_engine}"
  engine_version = "${var.rds_engine_version}"
  instance_class = "${var.rds_instance_class}"
  name = "${var.rds_name}"
  username = "${var.rds_username}"
  password = "${var.rds_password}"

  skip_final_snapshot = "true"

  vpc_security_group_ids = [
    "${aws_security_group.bitbucket_rds_security_group.id}"
  ]

  db_subnet_group_name = "${aws_db_subnet_group.bitbucket_rds_subnet_group.name}"
}

data "aws_iam_policy_document" "bitbucket_assume_role_policy_document" {

  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "bitbucket_iam_policy_document" {

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags",
      "ec2:Describe*",
      "autoscaling:Describe*"
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
      "logs:PutLogEvents"
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

resource "aws_iam_role" "bitbucket_role" {

  name = "${format("%s_%s_bitbucket_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  assume_role_policy = "${data.aws_iam_policy_document.bitbucket_assume_role_policy_document.json}"
}

resource "aws_iam_instance_profile" "bitbucket_instance_profile" {

  name = "${format("%s_%s_bitbucket_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  role = "${aws_iam_role.bitbucket_role.name}"
}

resource "aws_iam_policy" "bitbucket_iam_policy" {

  name = "${format("%s_%s_bitbucket_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  policy = "${data.aws_iam_policy_document.bitbucket_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "bitbucket_role_iam_policy_attachment" {

  role = "${aws_iam_role.bitbucket_role.name}"
  policy_arn = "${aws_iam_policy.bitbucket_iam_policy.arn}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user-data.tpl")}"

  vars {
    efs_id = "${aws_efs_file_system.bitbucket_efs.id}"
    ecs_cluster_name = "${format("%s_bitbucket_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_launch_configuration" "bitbucket_launch_configuration" {

  name_prefix = "${format("%s_bitbucket_%s_",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  image_id = "${coalesce(
        var.lc_ami_id,
        lookup(var.bitbucket_ami, var.aws_region)
    )}"
  instance_type = "${var.lc_instance_type}"
  associate_public_ip_address = "${var.lc_associate_public_ip_address}"
  key_name = "${aws_key_pair.bitbucket_key_pair.key_name}"
  security_groups = [
    "${aws_security_group.bitbucket_security_group.id}"
  ]

  iam_instance_profile = "${coalesce(
        var.lc_iam_instance_profile,
        aws_iam_instance_profile.bitbucket_instance_profile.name
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

resource "aws_autoscaling_group" "bitbucket_asg" {

  vpc_zone_identifier = [
    "${split(",", var.bitbucket_subnets)}"
  ]
  name = "${format("%s_bitbucket_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  desired_capacity = "${var.asg_desired_capacity}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type = "${var.asg_health_check_type}"
  force_delete = "${var.asg_force_delete}"
  launch_configuration = "${aws_launch_configuration.bitbucket_launch_configuration.name}"
  termination_policies = [
    "${var.asg_termination_policies}"
  ]

  tag {
    key = "Name"
    value = "${format("%s_bitbucket_%s",
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

data "template_file" "bitbucket_task_template" {
  template = "${file("${path.module}/templates/bitbucket.json.tpl")}"
}

resource "aws_ecs_cluster" "bitbucket_ecs_cluster" {
  name = "${format("%s_bitbucket_cluster_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
}

resource "aws_ecs_task_definition" "bitbucket_ecs_task" {
  family = "bitbucket"
  container_definitions = "${data.template_file.bitbucket_task_template.rendered}"

  volume {
    name = "efs-bitbucket"
    host_path = "/var/bitbucket"
  }
}

resource "aws_ecs_service" "bitbucket_ecs_service" {
  name = "${format("%s_bitbucket_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  cluster = "${aws_ecs_cluster.bitbucket_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.bitbucket_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.bitbucket_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.bitbucket_elb.name}"
    container_name = "bitbucket"
    container_port = 7990
  }

  depends_on = [
    "aws_autoscaling_group.bitbucket_asg"
  ]
}
