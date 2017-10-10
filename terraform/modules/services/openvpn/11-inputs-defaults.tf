variable "enable_debug" { default = "true" }

variable "associate_public_ip_address" { default = false }
variable "openvpn_ami_id" { default = "" }
variable "openvpn_instance_type" { default = "t2.micro" }
variable "disable_api_termination" { default = false }
variable "instance_initiated_shutdown_behavior" { default = "stop" }
variable "monitoring" { default = true }
variable "source_dest_check" { default = false }

variable "root_block_device_volume_type" { default = "gp2" }
variable "root_block_device_volume_size" { default = "20" }
variable "root_block_device_delete_on_termination" { default = false }


variable "openvpn_ami" {
    type = "map"
    description = "OpenVPN Access Server AMIs"
    default = {
        "eu-west-1" = "ami-1a8a6b63"
        "us-east-1" = "ami-d4e9d3c2"
        "ap-southeast-2" = "ami-cad7c5a9"
    }
}

variable "tag_Monitoring" { default = "On" }
variable "tag_resource_name" { default = "OpenVPN Server" }
variable "tag_service" { default = "OpenVPN" }