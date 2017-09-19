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
    App_Operations_Owner = "${var.tag_app_operations_owner}"
    System_Owner = "${var.tag_system_owner}"
    Budget_Owner = "${var.tag_budget_owner}"
    Created_By = "Terraform"
  }
}

data "aws_availability_zones" "available" {}
data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}
data "aws_vpc_endpoint_service" "dynamodb" {
  service = "dynamodb"
}
