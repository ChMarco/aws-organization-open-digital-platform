/*
 * Module: OpenVPN
 *
 * Components:
 *   - openvpn_key_pair
 *   - openvpn_security_group
 *   - openvpn_assume_role_policy_document
 *   - openvpn_iam_policy_document
 *   - openvpn_role
 *   - openvpn_instance_profile
 *   - openvpn_iam_policy
 *   - openvpn_role_iam_policy_attachment
 */

resource "aws_key_pair" "openvpn_key_pair" {

  key_name = "${format("%s_openvpn",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"
  public_key = "${var.openvpn_public_key}"
}

resource "aws_security_group" "openvpn_security_group" {

  name = "${format("%s_openvpn_ec2_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s OpenVPN Instances Security Group",
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
      "${var.openvpn_ssh_bastion_access}"
    ]
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_openvpn_ec2",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            )
        )
    )}"
}

resource "aws_security_group" "openvpn_elb_security_group" {

  name = "${format("%s_openvpn_elb_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  description = "${format("%s OpenVPN elb Security Group",
        title(lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"))
    )}"

  vpc_id = "${var.vpc_id}"

  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    protocol = "udp"
    from_port = 1194
    to_port = 1194
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

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
            "Name", format("%s_openvpn_elb_%s",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"

  lifecycle {
    create_before_destroy = "true"
  }

}

data "aws_iam_policy_document" "openvpn_assume_role_policy_document" {

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

data "aws_iam_policy_document" "openvpn_iam_policy_document" {

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

resource "aws_iam_role" "openvpn_role" {

  name = "${format("%s_%s_openvpn",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region
    )}"
  assume_role_policy = "${data.aws_iam_policy_document.openvpn_assume_role_policy_document.json}"
}

resource "aws_iam_instance_profile" "openvpn_instance_profile" {

  name = "${format("%s_%s_openvpn",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region
    )}"
  role = "${aws_iam_role.openvpn_role.name}"
}

resource "aws_iam_policy" "openvpn_iam_policy" {

  name = "${format("%s_%s_openvpn",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region
    )}"
  policy = "${data.aws_iam_policy_document.openvpn_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "openvpn_role_iam_policy_attachment" {

  role = "${aws_iam_role.openvpn_role.name}"
  policy_arn = "${aws_iam_policy.openvpn_iam_policy.arn}"
}

resource "aws_instance" "openvpn" {
  ami = "${coalesce(
        var.openvpn_ami_id,
        lookup(var.openvpn_ami, var.aws_region)
    )}"
  instance_type = "${var.openvpn_instance_type}"
  availability_zone = "${format("%s", element(data.aws_availability_zones.available.names, count.index))}"
  disable_api_termination = "${var.disable_api_termination}"
  instance_initiated_shutdown_behavior = "${var.instance_initiated_shutdown_behavior}"
  monitoring = "${var.monitoring}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  source_dest_check = "${var.source_dest_check}"

  key_name = "${aws_key_pair.openvpn_key_pair.key_name}"

  iam_instance_profile = "${aws_iam_instance_profile.openvpn_instance_profile.name}"

  vpc_security_group_ids = [
    "${aws_security_group.openvpn_security_group.id}"
  ]
  subnet_id = "${element(split(",", var.openvpn_subnets), count.index)}"

  user_data = <<USERDATA
admin_user=${var.openvpn_admin_user}
admin_pw=${var.openvpn_admin_pw}
USERDATA

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "${var.root_block_device_volume_type}"
    volume_size = "${var.root_block_device_volume_size}"
    delete_on_termination = "${var.root_block_device_delete_on_termination}"
  }

    provisioner "remote-exec" {
      connection {
        user = "openvpnas"
        host = "${self.public_ip}"
        private_key = "${file("${path.module}/id_rsa")}"
        timeout = "10m"
      }

      inline = [
        # Sleep 60 seconds until AMI is ready
        "sleep 60",

        # Set VPN network info
        "sudo /usr/local/openvpn_as/scripts/sacli -k vpn.daemon.0.client.network -v ${element(split("/", var.vpc_cidr), 0)} ConfigPut", 10.0.0.0/16

        "sudo /usr/local/openvpn_as/scripts/sacli -k vpn.daemon.0.client.netmask_bits -v ${element(split("/", var.vpc_cidr), 1)} ConfigPut",

        # Do a warm restart so the config is picked up
        "sudo /usr/local/openvpn_as/scripts/sacli start",
      ]
    }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s_openvpn_%s",
                  lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                  lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}

resource "aws_elb" "openvpn_elb" {

  name = "${format("%s-openvpn-%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  subnets = [
    "${split(",", var.openvpn_elb_subnets)}"
  ]
  instances = [
    "${aws_instance.openvpn.id}"
  ]

  security_groups = [
    "${aws_security_group.openvpn_security_group.id}",
    "${aws_security_group.openvpn_elb_security_group.id}"
  ]

  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  listener {
    instance_port = "80"
    instance_protocol = "http"
    lb_port = "80"
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 5
    target = "TCP:80"
    interval = "30"
  }

  tags = "${merge(
        data.null_data_source.tag_defaults.inputs,
        map(
            "Name", format("%s-openvpn-%s",
                  lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
                  lookup(data.null_data_source.tag_defaults.inputs, "Environment")
            )
        )
    )}"
}
