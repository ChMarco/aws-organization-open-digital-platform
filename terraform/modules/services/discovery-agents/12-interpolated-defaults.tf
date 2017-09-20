data "null_data_source" "vpc_defaults" {
  inputs = {
    name_prefix = "${format("%s",
            var.vpc_shortname
        )}"
  }
}


data "null_data_source" "tag_defaults" {
  inputs = {
    Environment = "${var.tag_environment}"
    Created_By = "Terraform"
  }
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}