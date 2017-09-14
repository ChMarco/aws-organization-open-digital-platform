module "codebuild_jenkins" {
  source = "../../modules/codebuild"

  aws_region = "${var.aws_region}"

  codebuild_name = "${var.jenkins_codebuild_name}"
  codebuild_repo = "${var.jenkins_codebuild_repo}"
  codebuild_ecr = "${var.jenkins_codebuild_ecr}"
  image_name = "${var.jenkins_image_name}"
}

module "codebuild_jenkins_slave" {
  source = "../../modules/codebuild"

  aws_region = "${var.aws_region}"

  codebuild_name = "${var.jenkins_slave_codebuild_name}"
  codebuild_repo = "${var.jenkins_slave_codebuild_repo}"
  codebuild_ecr = "${var.jenkins_slave_codebuild_ecr}"
  image_name = "${var.jenkins_slave_image_name}"
}