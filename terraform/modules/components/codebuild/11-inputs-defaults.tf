variable "base_aws_tags" {
  type = "map"
  default = {
    Created_By = "Terraform"
  }
}

variable "build_timeout" { default = "60" }