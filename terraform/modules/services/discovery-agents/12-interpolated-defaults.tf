data "null_data_source" "vpc_defaults" {
  inputs = {
    name_prefix = "${format("%s",
            var.vpc_shortname
        )}"
  }
}

variable "service_desired_count" { default = "1" }

data "null_data_source" "tag_defaults" {
  inputs = {
    Environment = "${var.tag_environment}"
    Created_By = "Terraform"
  }
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}