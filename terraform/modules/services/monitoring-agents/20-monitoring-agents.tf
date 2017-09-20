/*
 * Module: Monitoring Agents
 *
 * Components:
 *   - monitoring_cadvisor_ecs_task
 *   - monitoring_node_exporter_ecs_task
 *   - monitoring_cadvisor_ecs_service
 *   - monitoring_node_exporter_ecs_service
 */

data "template_file" "monitoring_cadvisor_task_template" {
  template = "${file("${path.module}/templates/monitoring_cadvisor.json.tpl")}"
}

data "template_file" "monitoring_node_exporter_task_template" {
  template = "${file("${path.module}/templates/monitoring_node_exporter.json.tpl")}"
}

resource "aws_ecs_task_definition" "monitoring_cadvisor_ecs_task" {
  family = "monitoring-agent"
  container_definitions = "${data.template_file.monitoring_cadvisor_task_template.rendered}"

  volume {
    name = "root"
    host_path = "/"
  }

  volume {
    name = "var_run"
    host_path = "/var/run"
  }

  volume {
    name = "sys"
    host_path = "/sys"
  }

  volume {
    name = "var_lib_docker"
    host_path = "/var/lib/docker/"
  }

  volume {
    name = "cgroup"
    host_path = "/cgroup"
  }
}

resource "aws_ecs_task_definition" "monitoring_node_exporter_ecs_task" {
  family = "monitoring-agent"
  container_definitions = "${data.template_file.monitoring_node_exporter_task_template.rendered}"

  network_mode = "host"
}

resource "aws_ecs_service" "monitoring_cadvisor_ecs_service" {
  name = "${format("%s_monitoring_cadvisor_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${var.ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.monitoring_cadvisor_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  placement_constraints {
    type = "${var.placement_constraints}"
  }
}

resource "aws_ecs_service" "monitoring_node_exporter_ecs_service" {
  name = "${format("%s_monitoring_node_exporter_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${var.ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.monitoring_node_exporter_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  placement_constraints {
    type = "${var.placement_constraints}"
  }
}