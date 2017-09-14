aws_region = "eu-west-1"
deploy_environment = "Test"

vpc_description = "Management VPC"
vpc_shortname = "ManagementVPC"
vpc_cidr_block = "10.0.0.0/16"
dmz_subnet_cidr_blocks = "10.0.128.0/20,10.0.144.0/20,10.0.160.0/20"
public_subnet_cidr_blocks = "10.0.0.0/19,10.0.32.0/19,10.0.64.0/19"
private_subnet_cidr_blocks = "10.0.192.0/21,10.0.200.0/21,10.0.208.0/21"

cloudtrail_bucket_name = "cloudtrail-test"

bastion_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
bastion_ssh_whitelist = {
  headoffice = "156.109.18.122/32"
}
provisioner_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"

jenkins_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
jenkins_image_tag = "9c541494-2c34-4100-a8d8-15b52f15133d"
jenkins_web_whitelist = {
  headoffice = "156.109.18.122/32",
  headoffice2 = "90.196.215.84/32",
  headoffice3 = "87.237.218.162/32",
}

bitbucket_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
bitbucket_web_whitelist = {
  headoffice = "156.109.18.122/32",
  headoffice2 = "81.157.227.241/32",
  headoffice2 = "87.237.218.162/32",
}

consul_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"

artifactory_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
artifactory_web_whitelist = {
  headoffice = "156.109.18.122/32",
  headoffice2 = "81.157.227.241/32",
  headoffice2 = "87.237.218.162/32",
}

jenkins_codebuild_name = "Jenkins"
jenkins_codebuild_ecr = "633665859024.dkr.ecr.eu-west-1.amazonaws.com"
jenkins_codebuild_repo = "jenkins"
jenkins_image_name = "jenkins"

jenkins_slave_codebuild_name = "Jenkins-Slave"
jenkins_slave_codebuild_ecr = "633665859024.dkr.ecr.eu-west-1.amazonaws.com"
jenkins_slave_codebuild_repo = "jenkins-slave"
jenkins_slave_image_name = "jenkins-slave"

#Tags

tag_resource_name = "General"
tag_project_name = "AODP"
tag_environment = "Test"
tag_cost_center = "iCode-"
tag_tier = "General"
tag_app_operations_owner = "Marco"
tag_system_owner = "Marco"
tag_budget_owner = "Marco"

tag_bastion_resource_name = "Bastion Server"
tag_bastion_project_name = "AODP"
tag_bastion_environment = "Test"
tag_bastion_cost_center = "iCode-"
tag_bastion_tier = "Bastion"
tag_bastion_app_operations_owner = "Marco"
tag_bastion_system_owner = "Marco"
tag_bastion_budget_owner = "Marco"

tag_jenkins_resource_name = "Jenkins Server"
tag_jenkins_project_name = "AODP"
tag_jenkins_environment = "Test"
tag_jenkins_cost_center = "iCode-"
tag_jenkins_tier = "Jenkins"
tag_jenkins_app_operations_owner = "Marco"
tag_jenkins_system_owner = "Marco"
tag_jenkins_budget_owner = "Marco"

tag_bitbucket_resource_name = "BitBucket Server"
tag_bitbucket_project_name = "AODP"
tag_bitbucket_environment = "Test"
tag_bitbucket_cost_center = ""
tag_bitbucket_tier = "BitBucket"
tag_bitbucket_app_operations_owner = "Marco"
tag_bitbucket_system_owner = "Marco"
tag_bitbucket_budget_owner = "Marco"

tag_openvpn_resource_name = "OpenVPN Server"
tag_openvpn_project_name = "AODP"
tag_openvpn_environment = "Test"
tag_openvpn_cost_center = "iCode-"
tag_openvpn_tier = "OpenVPN"
tag_openvpn_app_operations_owner = "Marco"
tag_openvpn_system_owner = "Marco"
tag_openvpn_budget_owner = "Marco"