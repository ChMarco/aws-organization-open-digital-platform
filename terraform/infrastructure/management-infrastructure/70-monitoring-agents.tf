# Monitoring

module "monitoring_agents_01" {
  source = "../../modules/services/agents-monitoring"

  vpc_shortname = "${var.vpc_shortname}"
  ecs_cluster = "${lookup(module.monitoring.monitoring_outputs, "monitoring_ecs_cluster_id")}"
  placement_constraints = "distinctInstance"
  service_desired_count = "1"

  monitoring_agent_cadvisor_ecs_task = "${lookup(module.monitoring.monitoring_outputs, "monitoring_agent_cadvisor_ecs_task_definition_arn")}"
  monitoring_agent_node_exporter_ecs_task = "${lookup(module.monitoring.monitoring_outputs, "monitoring_agent_node_exporter_ecs_task_definition_arn")}"

  tag_environment = "${var.tag_environment}"
}

# Discovery

module "monitoring_agents_02" {
  source = "../../modules/services/agents-monitoring"

  vpc_shortname = "${var.vpc_shortname}"
  ecs_cluster = "${lookup(module.discovery.discovery_outputs, "discovery_ecs_cluster_id")}"
  placement_constraints = "distinctInstance"
  service_desired_count = "3"

  monitoring_agent_cadvisor_ecs_task = "${lookup(module.monitoring.monitoring_outputs, "monitoring_agent_cadvisor_ecs_task_definition_arn")}"
  monitoring_agent_node_exporter_ecs_task = "${lookup(module.monitoring.monitoring_outputs, "monitoring_agent_node_exporter_ecs_task_definition_arn")}"

  tag_environment = "${var.tag_environment}"
}

# Jenkins

module "monitoring_agents_03" {
  source = "../../modules/services/agents-monitoring"

  vpc_shortname = "${var.vpc_shortname}"
  ecs_cluster = "${lookup(module.jenkins.jenkins_outputs, "jenkins_ecs_cluster_id")}"
  placement_constraints = "distinctInstance"
  service_desired_count = "1"

  monitoring_agent_cadvisor_ecs_task = "${lookup(module.monitoring.monitoring_outputs, "monitoring_agent_cadvisor_ecs_task_definition_arn")}"
  monitoring_agent_node_exporter_ecs_task = "${lookup(module.monitoring.monitoring_outputs, "monitoring_agent_node_exporter_ecs_task_definition_arn")}"

  tag_environment = "${var.tag_environment}"
}

# Secrets

module "monitoring_agents_04" {
  source = "../../modules/services/agents-monitoring"

  vpc_shortname = "${var.vpc_shortname}"
  ecs_cluster = "${lookup(module.secrets.vault_outputs, "vault_ecs_cluster_id")}"
  placement_constraints = "distinctInstance"
  service_desired_count = "1"

  monitoring_agent_cadvisor_ecs_task = "${lookup(module.monitoring.monitoring_outputs, "monitoring_agent_cadvisor_ecs_task_definition_arn")}"
  monitoring_agent_node_exporter_ecs_task = "${lookup(module.monitoring.monitoring_outputs, "monitoring_agent_node_exporter_ecs_task_definition_arn")}"

  tag_environment = "${var.tag_environment}"
}