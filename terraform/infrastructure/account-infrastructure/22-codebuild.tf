module "codebuild_jenkins" {
  source = "../../modules/components/codebuild"

  aws_region = "${var.aws_region}"

  codebuild_name = "${var.jenkins_codebuild_name}"
  codebuild_repo = "${var.jenkins_codebuild_repo}"

  account_id = "${var.account_id}"

  image_name = "${var.jenkins_image_name}"
}

module "codebuild_jenkins_slave" {
  source = "../../modules/components/codebuild"

  aws_region = "${var.aws_region}"

  codebuild_name = "${var.jenkins_slave_codebuild_name}"
  codebuild_repo = "${var.jenkins_slave_codebuild_repo}"

  account_id = "${var.account_id}"

  image_name = "${var.jenkins_slave_image_name}"
}

module "codebuild_vault" {
  source = "../../modules/components/codebuild"

  aws_region = "${var.aws_region}"

  codebuild_name = "${var.vault_codebuild_name}"
  codebuild_repo = "${var.vault_codebuild_repo}"

  account_id = "${var.account_id}"

  image_name = "${var.vault_image_name}"
}

module "codebuild_org" {
  source = "../../modules/components/codebuild"

  aws_region = "${var.aws_region}"

  codebuild_name = "${var.org_codebuild_name}"
  codebuild_repo = "${var.org_codebuild_repo}"

  account_id = "${var.account_id}"

  image_name = "${var.org_image_name}"
}