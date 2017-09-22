variable "ecs_cluster" {}
variable "vpc_shortname" {}
variable "tag_environment" {}
variable "placement_constraints" {}
variable "service_desired_count" {}

variable "monitoring_agent_node_exporter_ecs_task" {}
variable "monitoring_agent_cadvisor_ecs_task" {}