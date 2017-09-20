data "null_data_source" "outputs" {
  inputs {
    efs_backup_ecs_task_definition_arn = "${aws_ecs_task_definition.efs_backup_ecs_task.arn}"
    efs_backup_aws_cloudwatch_event_rule_arn = "${aws_cloudwatch_event_rule.efs_backup_cloudwatch_event_rule.arn}"
  }
}

output "efs_backup_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}