variable "aws_region" {}
variable "ecs_cluster" {}
variable "placement_constraints" {}
variable "service_desired_count" {}

variable "discovery_consul_agent_ecs_task" {}
variable "discovery_consul_registrator_ecs_task" {}

variable "vpc_shortname" {}
variable "tag_environment" {}