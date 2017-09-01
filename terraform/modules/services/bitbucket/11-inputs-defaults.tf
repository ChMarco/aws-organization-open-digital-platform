variable "base_aws_tags" {
  type = "map"
  default = {
    Role = "BitBucket"
    Created_By = "Terraform"
  }
}

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

variable "rds_instance_identifier" { default = "bitbucket" }
variable "rds_is_multi_az" { default = "true" }
variable "rds_allocated_storage" { default = "10" }
variable "rds_storage_type" { default = "gp2" }
variable "rds_engine" { default = "postgres" }
variable "rds_engine_version" { default = "9.6.3" }
variable "rds_instance_class" { default = "db.t2.medium" }
variable "rds_name" { default = "bitbucket" }
variable "rds_username" { default = "bitbucketadmin" }
variable "rds_password" { default = "NesGQbsiUYdNPoPHViXgacJ9" }

variable "service_desired_count" { default = "1" }

variable "bitbucket_ami" {
    type = "map"
    description = "AWS ECS optimized images"
    default = {
        "eu-west-1" = "ami-4e6ffe3d"
        "us-east-1" = "ami-8f7687e2"
        "ap-southeast-2" = "ami-697a540a"
    }
}
