
variable "enable_debug" { default = "false" }

variable "enable_classiclink" { default = "false" }
variable "enable_dns_support" { default = "true" }
variable "enable_dns_hostnames" { default = "true" }

variable "base_aws_tags" {
    type = "map"
    default = {
        Account = "Management"
        Billing = "Management"
        Role = "Management-VPC"
    }
}