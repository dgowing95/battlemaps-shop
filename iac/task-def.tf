resource "aws_ecs_task_definition" "battlemaps" {
    family = "battlemaps"
    execution_role_arn = aws_iam_role.battlemaps_exec_role.arn
    requires_compatibilities = [
        "FARGATE"
    ]
    network_mode = "awsvpc"
    container_definitions = jsonencode([
        {
            name = "battlemaps"
            image = "wordpress"
            cpu = 256
            memory = 512
            essential = true
            portMappings = [
                {
                    containerPort = 80
                }
            ]
        }
    ])
}