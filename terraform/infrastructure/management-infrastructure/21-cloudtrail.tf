module "cloudtrail" {
  source = "../../modules/cloudtrail"

  cloudtrail_bucket_name = "${var.cloudtrail_bucket_name}-${data.aws_caller_identity.current.account_id}"

}