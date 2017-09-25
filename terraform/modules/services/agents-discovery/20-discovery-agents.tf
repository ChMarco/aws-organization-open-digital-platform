/*
 * Module: Discovery Agents
 *
 * Components:
 *   - discovery_consul_agent_ecs_task
 *   - discovery_consul_agent_ecs_service
 *   - discovery_consul_registrator_ecs_task
 *   - discovery_consul_registrator_ecs_service
 */

## Agent

resource "aws_ecs_service" "discovery_consul_agent_ecs_service" {
  name = "${format("%s_discovery_consul_agent_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${var.ecs_cluster}"
  task_definition = "${var.discovery_consul_agent_ecs_task}"
  desired_count = "${var.service_desired_count}"

  placement_constraints {
    type = "${var.placement_constraints}"
  }

  lifecycle {
    ignore_changes = [
      "cluster"
    ]
  }
}

## Registrator

resource "aws_ecs_service" "discovery_consul_registrator_ecs_service" {
  name = "${format("%s_discovery_consul_registrator_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${var.ecs_cluster}"
  task_definition = "${var.discovery_consul_registrator_ecs_task}"
  desired_count = "${var.service_desired_count}"

  placement_constraints {
    type = "${var.placement_constraints}"
  }

  lifecycle {
    ignore_changes = [
      "cluster"
    ]
  }
}
