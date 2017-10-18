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

  name = "${format("%s_openvpn_ec2",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"
  description = "${format("%s OpenVPN Instances Security Group",
        title(lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"))
    )}"
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0"
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

  ingress {
    from_port = 443
    protocol = "6"
    to_port = 443
    cidr_blocks = [
      "0.0.0.0/0",
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

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_openvpn_ec2",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            ),
            "Service", "openvpn"
        )
    )}"
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

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_openvpn_ec2",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            ),
            "Service", "openvpn"
        )
    )}"
}

//resource "null_resource" "provision_openvpn" {
//  triggers {
//    subdomain_id = "${aws_route53_record.vpn.id}"
//  }
//
//  connection {
//    type = "ssh"
//    host = "${aws_instance.openvpn.public_ip}"
//    user = "${var.ssh_user}"
//    private_key = "${var.private_key}"
//    agent = false
//  }
//
//  provisioner "remote-exec" {
//    inline = [
//      "sudo apt-get install -y curl vim libltdl7 python3 python3-pip python software-properties-common unattended-upgrades",
//      "sudo add-apt-repository -y ppa:certbot/certbot",
//      "sudo apt-get -y update",
//      "sudo apt-get -y install python-certbot certbot",
//      "sudo service openvpnas stop",
//      "sudo certbot certonly --standalone --non-interactive --agree-tos --email ${var.certificate_email} --domains ${var.subdomain_name} --pre-hook 'service openvpnas stop' --post-hook 'service openvpnas start'",
//      "sudo ln -s -f /etc/letsencrypt/live/${var.subdomain_name}/cert.pem /usr/local/openvpn_as/etc/web-ssl/server.crt",
//      "sudo ln -s -f /etc/letsencrypt/live/${var.subdomain_name}/privkey.pem /usr/local/openvpn_as/etc/web-ssl/server.key",
//      "sudo service openvpnas start",
//    ]
//  }
//}