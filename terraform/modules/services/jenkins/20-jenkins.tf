/*
 * Module: Jenkins
 *
 * Components:
 *   - jenkins_key_pair
 *   - jenkins_security_group
 *   - jenkins_proxy_elb_security_group
 *   - jenkins_efs_security_group
 *   - jenkins_efs
 *   - jenkins_efs_mount_target
 *   - jenkins_elb
 *   - jenkins_proxy_elb
 *   - jenkins_assume_role_policy_document
 *   - jenkins_iam_policy_document
 *   - jenkins_role
 *   - jenkins_instance_profile
 *   - jenkins_iam_policy
 *   - jenkins_role_iam_policy_attachment
 *   - jenkins_launch_configuration
 *   - jenkins_asg
 *   - jenkins_ecs_cluster
 *   - jenkins_ecs_task
 *   - jenkins_proxy_ecs_task
 *   - jenkins_ecs_service
 *   - jenkins_proxy_ecs_service
 */

resource "aws_key_pair" "jenkins_key_pair" {

  key_name = "${format("%s_jenkins",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"
  public_key = "${var.jenkins_public_key}"
}

resource "aws_security_group" "jenkins_security_group" {

  name = "${format("%s_jenkins_ec2",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"
  description = "${format("%s Jenkins Instances Security Group",
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
      "${var.jenkins_ssh_bastion_access}"
    ]
  }

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_jenkins_ec2",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            ),
            "Service", "jenkins"
        )
    )}"
}

resource "aws_security_group" "jenkins_elb_security_group" {

  name = "${format("%s_jenkins_elb",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"
  description = "${format("%s Jenkins elb Security Group",
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
      "${aws_security_group.jenkins_security_group.id}"
    ]
  }

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_jenkins_elb",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            ),
            "Service", "jenkins"
        )
    )}"

  lifecycle {
    create_before_destroy = "true"
  }

}

resource "aws_security_group" "jenkins_proxy_elb_security_group" {

  name = "${format("%s_jenkins_proxy_elb",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"
  description = "${format("%s Jenkins proxy elb Security Group",
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
                      join(",", values(var.jenkins_web_whitelist)),
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
                      join(",", values(var.jenkins_web_whitelist)),
                      "0.0.0.0/0",
                      ""
                  )
              )
          )}"
    ]
  }

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_jenkins_proxy_elb",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            ),
            "Service", "jenkins"
        )
    )}"

  lifecycle {
    create_before_destroy = "true"
  }

}

resource "aws_security_group" "jenkins_efs_security_group" {

  name = "${format("%s_jenkins_efs",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"
  description = "${format("%s Jenkins efs Security Group",
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
      "${aws_security_group.jenkins_security_group.id}"
    ]
  }

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_jenkins_efs",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            ),
            "Service", "jenkins"
        )
    )}"
}

resource "aws_efs_file_system" "jenkins_efs" {

  performance_mode = "generalPurpose"

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_jenkins_efs",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            ),
            "Service", "jenkins"
        )
    )}"
}

resource "aws_efs_mount_target" "jenkins_efs_mount_target" {

  count = "${length(data.aws_availability_zones.available.names)}"

  file_system_id = "${aws_efs_file_system.jenkins_efs.id}"
  subnet_id = "${element(split(",", var.jenkins_subnets), count.index)}"
  security_groups = [
    "${aws_security_group.jenkins_efs_security_group.id}"
  ]
}

resource "aws_elb" "jenkins_elb" {

  name = "${format("%s-jenkins-elb",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"

  subnets = [
    "${split(",", var.jenkins_subnets)}",
  ]

  security_groups = [
    "${aws_security_group.jenkins_security_group.id}",
    "${aws_security_group.jenkins_elb_security_group.id}"
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
    target = "HTTP:8080/"
    interval = "30"
  }

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_jenkins_elb",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            ),
            "Service", "jenkins"
        )
    )}"
}

resource "aws_elb" "jenkins_proxy_elb" {

  name = "${format("%s-jenkins-proxy-elb",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"

  subnets = [
    "${split(",", var.jenkins_elb_subnets)}"
  ]

  security_groups = [
    "${aws_security_group.jenkins_security_group.id}",
    "${aws_security_group.jenkins_proxy_elb_security_group.id}"
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
    target = "HTTP:80/"
    interval = "30"
  }

  tags = "${merge(
        var.base_aws_tags,
        map(
            "Environment", var.deploy_environment,
            "Name", format("%s_jenkins_proxy_elb",
                lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
            ),
            "Service", "jenkins"
        )
    )}"
}

data "aws_iam_policy_document" "jenkins_assume_role_policy_document" {

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

data "aws_iam_policy_document" "jenkins_iam_policy_document" {

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

resource "aws_iam_role" "jenkins_role" {

  name = "${format("%s_%s_jenkins",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region
    )}"
  assume_role_policy = "${data.aws_iam_policy_document.jenkins_assume_role_policy_document.json}"
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {

  name = "${format("%s_%s_jenkins",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region
    )}"
  role = "${aws_iam_role.jenkins_role.name}"
}

resource "aws_iam_policy" "jenkins_iam_policy" {

  name = "${format("%s_%s_jenkins",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        var.aws_region
    )}"
  policy = "${data.aws_iam_policy_document.jenkins_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "jenkins_role_iam_policy_attachment" {

  role = "${aws_iam_role.jenkins_role.name}"
  policy_arn = "${aws_iam_policy.jenkins_iam_policy.arn}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user-data.tpl")}"

  vars {
    efs_id = "${aws_efs_file_system.jenkins_efs.id}"
    jenkins_elb_dns_name = "${aws_elb.jenkins_elb.dns_name}"
    ecs_cluster_name = "${format("%s_jenkins_cluster",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_launch_configuration" "jenkins_launch_configuration" {

  name_prefix = "${format("%s_jenkins_",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"

  image_id = "${coalesce(
        var.lc_ami_id,
        lookup(var.jenkins_ami, var.aws_region)
    )}"
  instance_type = "${var.lc_instance_type}"
  associate_public_ip_address = "${var.lc_associate_public_ip_address}"
  key_name = "${aws_key_pair.jenkins_key_pair.key_name}"
  security_groups = [
    "${aws_security_group.jenkins_security_group.id}"
  ]

  iam_instance_profile = "${coalesce(
        var.lc_iam_instance_profile,
        aws_iam_instance_profile.jenkins_instance_profile.name
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

resource "aws_autoscaling_group" "jenkins_asg" {

  vpc_zone_identifier = [
    "${split(",", var.jenkins_subnets)}"
  ]
  name = "${format("%s_jenkins",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"

  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  desired_capacity = "${var.asg_desired_capacity}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type = "${var.asg_health_check_type}"
  force_delete = "${var.asg_force_delete}"
  launch_configuration = "${aws_launch_configuration.jenkins_launch_configuration.name}"
  termination_policies = [
    "${var.asg_termination_policies}"
  ]

  tag {
    key = "Name"
    value = "${format("%s_jenkins",
          lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
      )}"
    propagate_at_launch = true
  }
  tag {
    key = "Role"
    value = "${lookup(var.base_aws_tags, "Role")}"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "${var.deploy_environment}"
    propagate_at_launch = true
  }
}

data "template_file" "jenkins_task_template" {
  template = "${file("${path.module}/templates/jenkins.json.tpl")}"
}

data "template_file" "jenkins_proxy_task_template" {
  template = "${file("${path.module}/templates/jenkins_proxy.json.tpl")}"
}

resource "aws_ecs_cluster" "jenkins_ecs_cluster" {
  name = "${format("%s_jenkins_cluster",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
    )}"
}

resource "aws_ecs_task_definition" "jenkins_ecs_task" {
  family = "jenkins"
  container_definitions = "${data.template_file.jenkins_task_template.rendered}"

  volume {
    name = "efs-jenkins"
    host_path = "/mnt/efs"
  }
}

resource "aws_ecs_task_definition" "jenkins_proxy_ecs_task" {
  family = "jenkins_proxy"
  container_definitions = "${data.template_file.jenkins_proxy_task_template.rendered}"

  volume {
    name = "nginx-conf"
    host_path = "/etc/nginx/nginx.conf"
  }
}

resource "aws_ecs_service" "jenkins_ecs_service" {
  name = "jenkins"
  cluster = "${aws_ecs_cluster.jenkins_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.jenkins_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.jenkins_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.jenkins_elb.name}"
    container_name = "jenkins"
    container_port = 8080
  }

  depends_on = [
    "aws_autoscaling_group.jenkins_asg"
  ]
}

resource "aws_ecs_service" "jenkins_proxy_ecs_service" {
  name = "jenkins_proxy"
  cluster = "${aws_ecs_cluster.jenkins_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.jenkins_proxy_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  iam_role = "${aws_iam_role.jenkins_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.jenkins_proxy_elb.name}"
    container_name = "nginx"
    container_port = 80
  }

  depends_on = [
    "aws_autoscaling_group.jenkins_asg"
  ]
}
