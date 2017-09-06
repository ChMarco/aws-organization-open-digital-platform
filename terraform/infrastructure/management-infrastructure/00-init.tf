terraform {
  required_version = ">= 0.10.2"

  backend "s3" {
    bucket = "adidas-terraform"
    region = "eu-west-1"
    access_key = "AKIAJ2KLWQLUCN67V6OA"
    secret_key = "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"
    acl = "bucket-owner-full-control"
  }
}

provider "aws" {
  access_key = "AKIAJ2KLWQLUCN67V6OA"
  secret_key = "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"
  region = "eu-west-1"
}