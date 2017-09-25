/*
 * Module: Monitoring Agents
 *
 * Components:
 *   - monitoring_cadvisor_ecs_service
 *   - monitoring_node_exporter_ecs_service
 */

resource "aws_ecs_service" "monitoring_cadvisor_ecs_service" {
  name = "${format("%s_monitoring_cadvisor_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${var.ecs_cluster}"
  task_definition = "${var.monitoring_agent_cadvisor_ecs_task}"
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

resource "aws_ecs_service" "monitoring_node_exporter_ecs_service" {
  name = "${format("%s_monitoring_node_exporter_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${var.ecs_cluster}"
  task_definition = "${var.monitoring_agent_node_exporter_ecs_task}"
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