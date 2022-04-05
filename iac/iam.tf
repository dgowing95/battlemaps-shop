resource "aws_iam_role" "battlemaps_exec_role" {
  name = "battlemaps_role"
  managed_policy_arns = [
    aws_iam_policy.battlemaps_exec_policy.arn
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "battlemaps_exec_policy" {
  name   = "battlemaps_exec_policy"
  policy = data.aws_iam_policy_document.battlemaps_exec_policy.json
}

data "aws_iam_policy_document" "battlemaps_exec_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:aws:logs:eu-north-1:688621974378:log-group:battlemaps-store:*"
    ]
  }
  statement {
    sid = "AllowTasksToUseDefaultKMS"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "AllowTasksToUseSSMKeys"
    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    resources = ["*"]
  }
  statement {
    sid = "AllowTasksToUseECR"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }

  statement {
    sid = "SSMDataChannels"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"]
  }
}