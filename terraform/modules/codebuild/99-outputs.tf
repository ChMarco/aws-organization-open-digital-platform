data "null_data_source" "outputs" {
  inputs {
    codebuild_repo_url = "${aws_ecr_repository.ecr_repository.repository_url}"
    codebuild_iam_role_arn = "${aws_iam_role.codebuild_role.arn}"
    codebuild_id = "${aws_codebuild_project.codebuild.id}"
  }
}

output "codebuild_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}