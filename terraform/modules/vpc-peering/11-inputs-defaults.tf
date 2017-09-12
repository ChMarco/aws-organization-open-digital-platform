data "aws_availability_zones" "available" {}
variable "enable_debug" {
  default = "true"
}

variable "base_aws_tags" {
  type = "map"
  default = {
    Created_By = "Terraform"
  }
}

variable "networks" { default = "DMZ,Private,Public" }