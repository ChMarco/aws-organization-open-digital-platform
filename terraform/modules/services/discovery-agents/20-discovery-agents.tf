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

data "template_file" "discovery_consul_agent_task_template" {
  template = "${file("${path.module}/templates/discovery_consul_agent.json.tpl")}"

  vars {
    bootstrap_expect = "${var.service_desired_count}"
    consul_dc = "${data.aws_caller_identity.current.account_id}-${var.aws_region}"
    join = "${format("%s_discovery_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"
  }
}

resource "aws_ecs_task_definition" "discovery_consul_agent_ecs_task" {
  family = "discovery"
  container_definitions = "${data.template_file.discovery_consul_agent_task_template.rendered}"

  task_role_arn = "${var.task_role}"

  network_mode = "host"

  volume {
    host_path = "/etc/consul.d"
    name = "consul_config"
  }

  volume {
    host_path = "/var/lib/consul"
    name = "consul_data"
  }
}

resource "aws_ecs_service" "discovery_consul_agent_ecs_service" {
  name = "${format("%s_discovery_consul_agent_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${var.ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.discovery_consul_agent_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  placement_constraints {
    type = "${var.placement_constraints}"
  }
}

## Registrator

data "template_file" "discovery_consul_registrator_task_template" {
  template = "${file("${path.module}/templates/discovery_consul_registrator.json.tpl")}"
}

resource "aws_ecs_task_definition" "discovery_consul_registrator_ecs_task" {
  family = "discovery"
  container_definitions = "${data.template_file.discovery_consul_registrator_task_template.rendered}"

  task_role_arn = "${var.task_role}"

  network_mode = "host"

  volume {
    host_path = "/opt/consul-registrator/bin"
    name = "consul_registrator_bin"
  }

  volume {
    host_path = "/var/run/docker.sock"
    name = "docker_socket"
  }
}

resource "aws_ecs_service" "discovery_consul_registrator_ecs_service" {
  name = "${format("%s_discovery_consul_registrator_service_%s",
        lookup(data.null_data_source.vpc_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
    )}"

  cluster = "${var.ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.discovery_consul_registrator_ecs_task.arn}"
  desired_count = "${var.service_desired_count}"

  placement_constraints {
    type = "${var.placement_constraints}"
  }
}
