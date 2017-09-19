data "null_data_source" "outputs" {
  inputs {
    monitoring_agent_cadvisor_ecs_task_definition_arn = "${aws_ecs_task_definition.monitoring_cadvisor_ecs_task.arn}"
    monitoring_agent_node_exporter_ecs_task_definition_arn = "${aws_ecs_task_definition.monitoring_node_exporter_ecs_task.arn}"
    monitoring_agent_cadvisor_ecs_service_id = "${aws_ecs_service.monitoring_cadvisor_ecs_service.id}"
    monitoring_agent_node_exporter_ecs_service_id = "${aws_ecs_service.monitoring_node_exporter_ecs_service.id}"
  }
}

output "monitoring_agents_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}