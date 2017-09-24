variable "enable_debug" { default = "true" }

variable "lc_associate_public_ip_address" { default = "false" }
variable "lc_ami_id" { default = "" }
variable "lc_instance_type" { default = "t2.medium" }
variable "lc_iam_instance_profile" { default = "" }
variable "lc_ebs_optimized" { default = "false" }
variable "lc_root_block_device" { default = "gp2:16:true" }

variable "asg_min_size" { default = "1" }
variable "asg_max_size" { default = "1" }
variable "asg_desired_capacity" { default = "1" }
variable "asg_health_check_type" { default = "EC2" }
variable "asg_force_delete" { default = "true" }
variable "asg_termination_policies" { default = "OldestInstance" }
variable "asg_health_check_grace_period" { default = "180" }

variable "service_desired_count" { default = "1" }

variable "monitoring_ami" {
    type = "map"
    description = "AWS ECS optimized images"
    default = {
        "eu-west-1" = "ami-4e6ffe3d"
        "us-east-1" = "ami-8f7687e2"
        "ap-southeast-2" = "ami-697a540a"
    }
}

variable "tag_resource_name" { default = "Monitoring Server" }
variable "tag_service" { default = "Monitoring" }