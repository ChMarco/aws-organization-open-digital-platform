output "vpc_peering_id" {
  value = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}