aws_region = "eu-west-1"
deploy_environment = "Stage"

vpc_description = "Management VPC"
vpc_shortname = "ManagementVPC"
vpc_cidr_block = "10.0.0.0/16"
dmz_subnet_cidr_blocks = "10.0.128.0/20,10.0.144.0/20,10.0.160.0/20"
public_subnet_cidr_blocks = "10.0.0.0/19,10.0.32.0/19,10.0.64.0/19"
private_subnet_cidr_blocks = "10.0.192.0/21,10.0.200.0/21,10.0.208.0/21"

cloudtrail_bucket_name = "cloudtrail"

bastion_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
bastion_ssh_whitelist = {
  headoffice = "156.109.18.122/32"
}
provisioner_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"