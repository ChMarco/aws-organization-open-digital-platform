data "null_data_source" "vpc_defaults" {
  inputs = {
    name_prefix = "${format("%s",
            var.vpc_shortname
        )}"
  }
}

data "null_data_source" "tag_defaults" {
  inputs = {
    Resource_Name = "${var.tag_resource_name}"
    Project_Name = "${var.tag_project_name}"
    Environment = "${var.tag_environment}"
    Cost_Center = "${var.tag_cost_center}"
    Tier = "${var.tag_tier}"
    App_Operations_Owner = "${var.tag_app_operations_owner}"
    System_Owner = "${var.tag_system_owner}"
    Budget_Owner = "${var.tag_budget_owner}"
    Created_By = "Terraform"
  }
}


data "aws_subnet_ids" "mgmt_subnets" {

  count = "${length(split(",", var.networks))}"
  vpc_id = "${var.mgmt_vpc_id}"

  tags {
    Network = "${element(split(",", var.networks), count.index)}"
  }
}

data "aws_route_table" "mgmt_dmz_route_tables" {

  count = "${length(split(",", var.networks))}"
  subnet_id = "${element(data.aws_subnet_ids.mgmt_subnets.0.ids, count.index)}"

}

data "aws_route_table" "mgmt_private_route_tables" {

  count = "${length(split(",", var.networks))}"
  subnet_id = "${element(data.aws_subnet_ids.mgmt_subnets.1.ids, count.index)}"

}

data "aws_route_table" "mgmt_public_route_tables" {

  count = "${length(split(",", var.networks))}"
  subnet_id = "${element(data.aws_subnet_ids.mgmt_subnets.2.ids, count.index)}"

}