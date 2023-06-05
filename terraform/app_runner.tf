data "aws_iam_policy_document" "app_runner" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com", "tasks.apprunner.amazonaws.com"]
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
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_apprunner_service" "app_runner" {
  service_name = var.project
  source_configuration {
    image_repository {
      image_configuration {
        port = 8000
        runtime_environment_variables = {
          PORT           = 8000
          DYNAMODB_TABLE = aws_dynamodb_table.dynamodb_table.id
        }
      }
      image_identifier      = "384447982274.dkr.ecr.ap-northeast-1.amazonaws.com/refactored-dollop:latest"
      image_repository_type = "ECR"
    }
    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner.arn
    }
  }
}

output "app_runner_url" {
  value = aws_apprunner_service.app_runner.service_url
}