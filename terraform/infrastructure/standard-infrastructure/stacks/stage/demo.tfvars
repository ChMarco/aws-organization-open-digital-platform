aws_region = "eu-west-1"
deploy_environment = "Stage"

vpc_description = "Standard VPC"
vpc_shortname = "StandardVPC"
vpc_cidr_block = "10.1.0.0/16"
dmz_subnet_cidr_blocks = "10.1.128.0/20,10.1.144.0/20,10.1.160.0/20"
public_subnet_cidr_blocks = "10.1.0.0/19,10.1.32.0/19,10.1.64.0/19"
private_subnet_cidr_blocks = "10.1.192.0/21,10.1.200.0/21,10.1.208.0/21"

cloudtrail_bucket_name = "cloudtrail"

bastion_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
bastion_ssh_whitelist = {
  headoffice = "156.109.18.122/32"
}
provisioner_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"

mgmt_vpc_id = "vpc-7835511f"
mgmt_vpc_cidr = "10.0.0.0/16"

tag_resource_name = "General"
tag_project_name = "AODP-Standard-Demo"
tag_environment = "Stage"
tag_cost_center = "iCode-"
tag_tier = "General"
tag_app_operations_owner = "Marco"
tag_system_owner = "Marco"
tag_budget_owner = "Marco"

tag_bastion_resource_name = "Bastion Server"
tag_bastion_project_name = "AODP-Standard-Demo"
tag_bastion_environment = "Stage"
tag_bastion_cost_center = "iCode-"
tag_bastion_tier = "Bastion"
tag_bastion_app_operations_owner = "Marco"
tag_bastion_system_owner = "Marco"
tag_bastion_budget_owner = "Marco"