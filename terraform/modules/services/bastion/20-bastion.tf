/*
 * Module: Bastion
 *
 * Components:
 *   - bastion_key_pair
 *   - bastion_security_group
 *   - bastion_assume_role_policy_document
 *   - bastion_iam_policy_document
 *   - bastion_role
 *   - bastion_instance_profile
 *   - bastion_iam_policy
 *   - bastion_role_iam_policy_attachment
 *   - bastion_eip
 *   - bastion_launch_configuration
 *   - bastion_asg
 */

resource "aws_key_pair" "bastion_key_pair" {

  key_name = "${format("%s_bastion_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  public_key = "${var.bastion_public_key}"
}

resource "aws_security_group" "bastion_security_group" {

  name = "${format("%s_bastion_ec2_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s Bastion Instances Security Group",
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
    from_port = 22
    protocol = "6"
    to_port = 22
    cidr_blocks = [
      "${compact(
              split(",",
                  replace(
                      join(",", values(var.bastion_ssh_whitelist)),
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
            "Name", format("%s_bastion_ec2_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

data "aws_iam_policy_document" "bastion_assume_role_policy_document" {

  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "bastion_iam_policy_document" {

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
}

resource "aws_iam_role" "bastion_role" {

  name = "${format("%s_%s_bastion_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")

    )}"
  assume_role_policy = "${data.aws_iam_policy_document.bastion_assume_role_policy_document.json}"
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {

  name = "${format("%s_%s_bastion_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  role = "${aws_iam_role.bastion_role.name}"
}

resource "aws_iam_policy" "bastion_iam_policy" {

  name = "${format("%s_%s_bastion_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region,
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  policy = "${data.aws_iam_policy_document.bastion_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "bastion_role_iam_policy_attachment" {

  role = "${aws_iam_role.bastion_role.name}"
  policy_arn = "${aws_iam_policy.bastion_iam_policy.arn}"
}

resource "aws_eip" "bastion_eip" {

  vpc = true
}

data "template_file" "user_data" {

  template = "${file("${path.module}/templates/bastion-cloud-config.yml")}"

  vars {
    username = "${var.provisioner_username}"
    ssh_pub_key = "${var.provisioner_ssh_public_key}"
    eip_allocation_id = "${aws_eip.bastion_eip.id}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_launch_configuration" "bastion_launch_configuration" {

  name_prefix = "${format("%s_bastion_%s_",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  image_id = "${coalesce(
        var.lc_ami_id,
        lookup(var.bastion_ami, var.aws_region)
    )}"
  instance_type = "${var.lc_instance_type}"
  associate_public_ip_address = "${var.lc_associate_public_ip_address}"
  key_name = "${aws_key_pair.bastion_key_pair.key_name}"
  security_groups = [
    "${aws_security_group.bastion_security_group.id}",
    "${var.monitoring_security_group}"
  ]

  iam_instance_profile = "${coalesce(
        var.lc_iam_instance_profile,
        aws_iam_instance_profile.bastion_instance_profile.name
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

resource "aws_autoscaling_group" "bastion_asg" {

  vpc_zone_identifier = [
    "${split(",", var.bastion_subnets)}"
  ]
  name = "${format("%s_bastion_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  desired_capacity = "${var.asg_desired_capacity}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type = "${var.asg_health_check_type}"
  force_delete = "${var.asg_force_delete}"
  launch_configuration = "${aws_launch_configuration.bastion_launch_configuration.name}"
  termination_policies = [
    "${var.asg_termination_policies}"]

  tag {
    key = "Name"
    value = "${format("%s_bastion_%s",
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
