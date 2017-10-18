# General
account_id = "633665859024"
aws_region = "eu-west-1"
deploy_environment = "Test"
ssh_web_whitelist = "156.109.18.122/32,90.196.215.84/32,87.237.218.162/32"

vpc_description = "Management VPC"
vpc_shortname = "Management"
vpc_cidr_block = "10.0.0.0/16"
dmz_subnet_cidr_blocks = "10.0.128.0/20,10.0.144.0/20,10.0.160.0/20"
public_subnet_cidr_blocks = "10.0.0.0/19,10.0.32.0/19,10.0.64.0/19"
private_subnet_cidr_blocks = "10.0.192.0/21,10.0.200.0/21,10.0.208.0/21"

management_keypair = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
jenkins_image_tag = "b33397e4-c173-4c61-bf4c-ba34dd654e78"
vault_image_tag = "10e08be6-bd1e-400b-9d42-b38f380bb1f5"
consul_acl_master_token_uuid = "04AEB3B2-45BD-4FCE-9137-ED54BD44023B"

## Tags

tag_project_name = "AODP"
tag_environment = "Test"
tag_cost_center = "iCode-I44534"
tag_app_operations_owner = "Marco Chiapusso"
tag_system_owner = "Marco Chiapusso"
tag_budget_owner = "Marco Chiapusso"
