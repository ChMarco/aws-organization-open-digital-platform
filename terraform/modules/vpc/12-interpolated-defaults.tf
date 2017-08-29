data "null_data_source" "vpc_defaults" {
    inputs = {
        name_prefix = "${format("%s",
            var.vpc_shortname
        )}"
    }
}

data "aws_availability_zones" "available" {}
data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}
data "aws_vpc_endpoint_service" "dynamodb" {
  service = "dynamodb"
}
