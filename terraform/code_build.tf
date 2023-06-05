data "aws_iam_policy_document" "code_build" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "code_build" {
  name               = var.project
  assume_role_policy = data.aws_iam_policy_document.code_build.json
}

resource "aws_codebuild_project" "code_build" {
  name         = var.project
  service_role = aws_iam_role.code_build.arn
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    type         = "LINUX_CONTAINER"
    image        = "aws/codebuild/standard:7.0"
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type     = "GITHUB"
    location = "https://github.com/hsmtkk/refactored-dollop"
  }
}