resource "aws_ecs_service" "battlemaps" {
    name = "Battlemaps"
    cluster = aws_ecs_cluster.main.id
    desired_count = 1
    depends_on = [
      aws_iam_policy.battlemaps_exec_policy
    ]

    network_configuration {
      subnets = aws_subnet.private.*.id
      security_groups = [
          aws_security_group.nat_egress.id
      ]
    }
}