terraform {
  required_version = ">= 0.10.2"

  backend "s3" {
    bucket = "adidas-terraform"
    acl = "bucket-owner-full-control"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}