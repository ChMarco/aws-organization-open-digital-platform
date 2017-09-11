variable "aws_region" {}

variable "vpc_id" {}
variable "vpc_cidr" {}
variable "vpc_shortname" {}

variable "openvpn_public_key" {}
variable "openvpn_subnets" {}

variable "openvpn_admin_user" { default = "provisioner" }
variable "openvpn_admin_pw" { default = "oV3NydFDRiBTxUuGAFjtLPoF" }

variable "deploy_environment" {}
