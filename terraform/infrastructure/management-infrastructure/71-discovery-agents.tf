# Monitoring

module "discovery_agents_01" {
  source = "../../modules/services/agents-discovery"

  aws_region = "${var.aws_region}"

  vpc_shortname = "${var.vpc_shortname}"
  ecs_cluster = "${lookup(module.monitoring.monitoring_outputs, "monitoring_ecs_cluster_id")}"
  placement_constraints = "distinctInstance"
  service_desired_count = "1"

  discovery_consul_agent_ecs_task = "${lookup(module.discovery.discovery_outputs, "discovery_consul_agent_ecs_task_definition_arn")}"
  discovery_consul_registrator_ecs_task = "${lookup(module.discovery.discovery_outputs, "discovery_consul_registrator_ecs_task_definition_arn")}"

  tag_environment = "${var.tag_environment}"

}

# Jenkins

module "discovery_agents_02" {
  source = "../../modules/services/agents-discovery"

  aws_region = "${var.aws_region}"

  vpc_shortname = "${var.vpc_shortname}"
  ecs_cluster = "${lookup(module.jenkins.jenkins_outputs, "jenkins_ecs_cluster_id")}"
  placement_constraints = "distinctInstance"
  service_desired_count = "1"

  discovery_consul_agent_ecs_task = "${lookup(module.discovery.discovery_outputs, "discovery_consul_agent_ecs_task_definition_arn")}"
  discovery_consul_registrator_ecs_task = "${lookup(module.discovery.discovery_outputs, "discovery_consul_registrator_ecs_task_definition_arn")}"

  tag_environment = "${var.tag_environment}"

}

# Secrets

module "discovery_agents_03" {
  source = "../../modules/services/agents-discovery"

  aws_region = "${var.aws_region}"

  vpc_shortname = "${var.vpc_shortname}"
  ecs_cluster = "${lookup(module.secrets.vault_outputs, "vault_ecs_cluster_id")}"
  placement_constraints = "distinctInstance"
  service_desired_count = "1"

  discovery_consul_agent_ecs_task = "${lookup(module.discovery.discovery_outputs, "discovery_consul_agent_ecs_task_definition_arn")}"
  discovery_consul_registrator_ecs_task = "${lookup(module.discovery.discovery_outputs, "discovery_consul_registrator_ecs_task_definition_arn")}"

  tag_environment = "${var.tag_environment}"

}