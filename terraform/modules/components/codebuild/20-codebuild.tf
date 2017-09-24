/*
 * Module: CodeBuild
 *
 * Components:
 *   - CodeBuild
 */

#--------------------------------------------------------------
# CodeBuild
#--------------------------------------------------------------

resource "aws_ecr_repository" "ecr_repository" {
  name = "${var.codebuild_repo}"
}

resource "aws_iam_role" "codebuild_role" {
  name = "${format("%s_%s_codebuild-role",
        data.aws_caller_identity.current.account_id,
        var.aws_region
    )}_${var.codebuild_repo}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "${format("%s_%s_codebuild-policy",
        data.aws_caller_identity.current.account_id,
        var.aws_region
    )}_${var.codebuild_repo}"

  path = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "s3:*",
        "ecr:*",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name = "${format("%s_%s_codebuild-policy-attachment",
        data.aws_caller_identity.current.account_id,
        var.aws_region
    )}_${var.codebuild_repo}"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles = [
    "${aws_iam_role.codebuild_role.id}"]
}

resource "aws_codebuild_project" "codebuild" {

  name = "${var.codebuild_name}"
  description = "CodeBuild Project for ${var.codebuild_name}"

  service_role = "${aws_iam_role.codebuild_role.arn}"

  build_timeout = "${var.build_timeout}"

  "artifacts" {
    type = "NO_ARTIFACTS"
  }
  "environment" {
    compute_type = "BUILD_GENERAL1_LARGE"
    image = "aws/codebuild/docker:1.12.1"
    type = "LINUX_CONTAINER"
    privileged_mode = "true"

    environment_variable {
      "name" = "IMAGE"
      "value" = "${var.image_name}"
    }

    environment_variable {
      "name" = "REPO"
      "value" = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    }
  }
  "source" {
    type = "S3"
    location = "${var.account_id}-infrastructure-terraform/terraform-codebuild/${var.image_name}.zip"
  }

  tags = "${var.base_aws_tags}"
}