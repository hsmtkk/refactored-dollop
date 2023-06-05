data "aws_iam_policy_document" "app_runner" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["tasks.apprunner.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "app_runner" {
  name               = "${var.project}-app_runner"
  assume_role_policy = data.aws_iam_policy_document.app_runner.json
}

resource "aws_iam_role_policy_attachment" "app_runner" {
  role       = aws_iam_role.app_runner.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_apprunner_service" "app_runner" {
  service_name = var.project
  source_configuration {
    image_repository {
      image_identifier      = "384447982274.dkr.ecr.ap-northeast-1.amazonaws.com/refactored-dollop:latest"
      image_repository_type = "ECR"
    }
    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner.arn
    }

  }
}