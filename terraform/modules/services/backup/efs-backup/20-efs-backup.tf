/*
 * Module: EFS Backup
 *
 * Components:
 *   - efs_backup_cloudwatch_event_rule
 *   - efs_backup_cloudwatch_event_target
 *   - efs_backup_ecs_task
 */

data "template_file" "efs_backup_ecs_task_template" {
  template = "${file("${path.module}/templates/efs_backup.json.tpl")}"

  vars {
    efs_id = "${var.efs_id}"
    efs_name = "${var.efs_name}"
    access_key = "AKIAJ2KLWQLUCN67V6OA"
    secret_key = "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"
    backup_bucket = "${var.backup_bucket}"
    aws_region = "${var.aws_region}"
  }

}

resource "aws_ecs_task_definition" "efs_backup_ecs_task" {
  family = "efs-backup"
  container_definitions = "${data.template_file.efs_backup_ecs_task_template.rendered}"

}

resource "aws_cloudwatch_event_rule" "efs_backup_cloudwatch_event_rule" {
  name = "${format("%s_efs_backup_%s_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment"),
        var.stack_name
    )}"

  description = "${format("%s %s EFS backup CloudWatch Rule",
        title(
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix")
        ),
        var.stack_name
    )}"

  schedule_expression = "rate(1440 minutes)"
  is_enabled = true
}

resource "aws_cloudwatch_event_target" "efs_backup_cloudwatch_event_target" {
  arn = "${var.ecs_cluster}"
  role_arn = "${var.task_role}"

  rule = "${aws_cloudwatch_event_rule.efs_backup_cloudwatch_event_rule.name}"

  ecs_target {

    task_definition_arn = "${aws_ecs_task_definition.efs_backup_ecs_task.arn}"
    task_count = "${var.service_desired_count}"

  }
}