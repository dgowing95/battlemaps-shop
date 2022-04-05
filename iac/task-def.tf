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
            mountPoints = [
                {
                    containerPath = "/var/www/html/wp-content/themes"
                    sourceVolume = "battlemaps-efs-themes"
                },
                {
                    containerPath = "/var/www/html/wp-content/plugins"
                    sourceVolume = "battlemaps-efs-plugins"
                },
                {
                    containerPath = "/var/www/html/wp-content/uploads"
                    sourceVolume = "battlemaps-efs-uploads"
                }
            ]
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                "awslogs-group"         = "battlemaps-store"
                "awslogs-region"        = var.region
                "awslogs-stream-prefix" = "ecs"
                }
            }
        }
    ])
    volume {
      name = "battlemaps-efs-themes"

      efs_volume_configuration {
        file_system_id = aws_efs_file_system.battlemaps.id
        root_directory = "/themes"
        transit_encryption = "ENABLED"
        authorization_config {
          access_point_id = aws_efs_access_point.battlemaps-access.id
        }
      }
    }
    volume {
      name = "battlemaps-efs-plugins"

      efs_volume_configuration {
        file_system_id = aws_efs_file_system.battlemaps.id
        root_directory = "/plugins"
        transit_encryption = "ENABLED"
        authorization_config {
          access_point_id = aws_efs_access_point.battlemaps-access.id
        }
      }
    }
    volume {
      name = "battlemaps-efs-uploads"

      efs_volume_configuration {
        file_system_id = aws_efs_file_system.battlemaps.id
        root_directory = "/uploads"
        transit_encryption = "ENABLED"
        authorization_config {
          access_point_id = aws_efs_access_point.battlemaps-access.id
        }
      }
    }
}