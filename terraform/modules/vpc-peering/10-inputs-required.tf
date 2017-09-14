variable "mgmt_vpc_id" {}
variable "mgmt_vpc_cidr" {}
variable "mgmt_vpc_shortname" {}

variable "vpc_id" {}
variable "vpc_cidr" {}
variable "vpc_shortname" {}
variable "public_route_tables" {}
variable "private_route_tables" {}
variable "dmz_route_tables" {}

variable "deploy_environment" {}

# Tags
variable "tag_resource_name" {}
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_tier" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}