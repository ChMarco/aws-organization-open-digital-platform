data "null_data_source" "outputs" {
  inputs {
    discovery_consul_agent_ecs_service_id = "${aws_ecs_service.discovery_consul_agent_ecs_service.id}"
    discovery_consul_registrator_ecs_service_id = "${aws_ecs_service.discovery_consul_registrator_ecs_service.id}"
  }
}

output "discovery_agents_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}