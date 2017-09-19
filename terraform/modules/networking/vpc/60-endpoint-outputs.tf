/*
 * Module: VPC
 *
 * Outputs
 *
 */

data "null_data_source" "endpoints_outputs" {
  inputs {
    s3_vpc_endpoint_id = "${aws_vpc_endpoint.s3_endpoint.id}"
    dynamodb_vpc_endpoint_id = "${aws_vpc_endpoint.dynamodb_endpoint.id}"
  }
}
