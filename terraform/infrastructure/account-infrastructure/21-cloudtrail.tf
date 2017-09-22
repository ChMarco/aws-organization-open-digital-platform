module "cloudtrail" {
  source = "../../modules/components/cloudtrail"

  account_id = "${var.account_id}"

}