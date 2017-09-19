data "aws_availability_zones" "available" {}
variable "enable_debug" {
  default = "true"
}
variable "networks" { default = "DMZ,Private,Public" }