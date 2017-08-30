/*
 * Module: Launch Configuration
 *
 * Components:
 *   -
 */

# Simple user-data template to boostrap the instance(s)
data "template_file" "app_user_data" {
    template = "${file(format("%s/%s",
        path.module,
        "user-data/config.tpl"
        ))}"
}

resource "aws_launch_configuration" "lc" {
  name_prefix = "open_digital-"

  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name = "${var.ssh_key_name}"

  security_groups = [
    "${var.security_group}"
  ]

  root_block_device {
    volume_size = "${var.volume_size}"
    volume_type = "${var.volume_type}"
  }

  enable_monitoring = true

  associate_public_ip_address = "${var.associate_public_ip_address}"

  lifecycle {
    create_before_destroy = true
  }
}
