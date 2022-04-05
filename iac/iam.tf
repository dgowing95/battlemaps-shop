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
    name = "battlemaps_exec_policy"
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
}