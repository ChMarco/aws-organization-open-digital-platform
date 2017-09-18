aws_region = "eu-west-1"
deploy_environment = "Production"

vpc_description = "Management VPC"
vpc_shortname = "Management"
vpc_cidr_block = "10.0.0.0/16"
dmz_subnet_cidr_blocks = "10.0.128.0/20,10.0.144.0/20,10.0.160.0/20"
public_subnet_cidr_blocks = "10.0.0.0/19,10.0.32.0/19,10.0.64.0/19"
private_subnet_cidr_blocks = "10.0.192.0/21,10.0.200.0/21,10.0.208.0/21"

# CodeBuild

jenkins_codebuild_name = "Jenkins"
jenkins_codebuild_ecr = "633665859024.dkr.ecr.eu-west-1.amazonaws.com"
jenkins_codebuild_repo = "jenkins"
jenkins_image_name = "jenkins"

jenkins_slave_codebuild_name = "Jenkins-Slave"
jenkins_slave_codebuild_ecr = "633665859024.dkr.ecr.eu-west-1.amazonaws.com"
jenkins_slave_codebuild_repo = "jenkins-slave"
jenkins_slave_image_name = "jenkins-slave"

# Bastion

bastion_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
bastion_ssh_whitelist = {
  headoffice = "156.109.18.122/32"
}
provisioner_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"

tag_bastion_resource_name = "Bastion Server"
tag_bastion_project_name = "AODP"
tag_bastion_environment = "Production"
tag_bastion_cost_center = "iCode-"
tag_bastion_service = "Bastion"
tag_bastion_app_operations_owner = "March Chiapusso"
tag_bastion_system_owner = "March Chiapusso"
tag_bastion_budget_owner = "March Chiapusso"

# Jenkins

jenkins_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
jenkins_image_tag = "9c541494-2c34-4100-a8d8-15b52f15133d"
jenkins_web_whitelist = {
  headoffice = "156.109.18.122/32",
  headoffice2 = "90.196.215.84/32",
  headoffice3 = "87.237.218.162/32",
}

tag_jenkins_resource_name = "Jenkins Server"
tag_jenkins_project_name = "AODP"
tag_jenkins_environment = "Production"
tag_jenkins_cost_center = "iCode-"
tag_jenkins_service = "Jenkins"
tag_jenkins_app_operations_owner = "March Chiapusso"
tag_jenkins_system_owner = "March Chiapusso"
tag_jenkins_budget_owner = "March Chiapusso"

# BitBucket

bitbucket_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
bitbucket_web_whitelist = {
  headoffice = "156.109.18.122/32",
  headoffice2 = "81.157.227.241/32",
  headoffice2 = "87.237.218.162/32",
}

tag_bitbucket_resource_name = "BitBucket Server"
tag_bitbucket_project_name = "AODP"
tag_bitbucket_environment = "Production"
tag_bitbucket_cost_center = ""
tag_bitbucket_service = "BitBucket"
tag_bitbucket_app_operations_owner = "March Chiapusso"
tag_bitbucket_system_owner = "March Chiapusso"
tag_bitbucket_budget_owner = "March Chiapusso"

# Monitoring

monitoring_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
monitoring_web_whitelist = {
  headoffice = "156.109.18.122/32",
  headoffice2 = "81.157.227.241/32",
  headoffice2 = "87.237.218.162/32",
}

tag_monitoring_resource_name = "Monitoring Server"
tag_monitoring_project_name = "AODP"
tag_monitoring_environment = "Production"
tag_monitoring_cost_center = "iCode-"
tag_monitoring_service = "Monitoring"
tag_monitoring_app_operations_owner = "Marco Chiapusso"
tag_monitoring_system_owner = "Marco Chiapusso"
tag_monitoring_budget_owner = "Marco Chiapusso"

# Discovery

discovery_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIa/BQQ0obYuEJasZVtyTnjSsm3BxIXCbHBfGenJvfnmAy75Mt9r+70COVBiNDA2DCTWQkQTRvHn3AzyapWH5Q/bLPOjxBpvH1zHM/Fu6CjOjesuYoDNj6307hCOpr7xiMXm+WqlqaMH1eRwHCTJ+FNBaqjXbosspscF0SyEnk5w0JNXiGAXsx2m6YjyQvSYza0gJ4HixVQZcCUYzjAzqV1Dgj8dzfYl+YVA9bTTq+8aOMYGA75Zre6fH6rQg+Br0O7B/ytvStyI7OCRZLY84k58ugrFabXUWGis+ZtxIjFA1n59nybKpwDAGrEzXF4h4xbj4OHomn2h90jJPC8ZOX mohammed@moh-abks-MacBook.local"
discovery_web_whitelist = {
  headoffice = "156.109.18.122/32",
  headoffice2 = "81.157.227.241/32",
  headoffice2 = "87.237.218.162/32",
}

tag_discoveryresource_name = "Monitoring Server"
tag_discoveryproject_name = "AODP"
tag_discoveryenvironment = "Production"
tag_discoverycost_center = "iCode-"
tag_discoveryservice = "Monitoring"
tag_discoveryapp_operations_owner = "Marco Chiapusso"
tag_discoverysystem_owner = "Marco Chiapusso"
tag_discoverybudget_owner = "Marco Chiapusso"

# General Tags

tag_resource_name = "General"
tag_project_name = "AODP"
tag_environment = "Production"
tag_cost_center = "iCode-"
tag_tier = "General"
tag_app_operations_owner = "March Chiapusso"
tag_system_owner = "March Chiapusso"
tag_budget_owner = "March Chiapusso"