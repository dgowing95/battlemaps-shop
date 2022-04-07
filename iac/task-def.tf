resource "aws_ecs_task_definition" "battlemaps" {
  family             = "battlemaps"
  execution_role_arn = aws_iam_role.battlemaps_exec_role.arn
  requires_compatibilities = [
    "FARGATE"
  ]
  network_mode = "awsvpc"
  cpu          = 256
  memory       = 512
  container_definitions = jsonencode([
    {
      name      = "battlemaps"
      image     = "minichambre/wordpress:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
        }
      ]
      mountPoints = [
        {
          containerPath = "/var/www/html/wp-content/themes"
          sourceVolume  = "battlemaps-efs-themes"
        },
        {
          containerPath = "/var/www/html/wp-content/plugins"
          sourceVolume  = "battlemaps-efs-plugins"
        },
        {
          containerPath = "/var/www/html/wp-content/uploads"
          sourceVolume  = "battlemaps-efs-uploads"
        }
      ],
      secrets = [
        {
          name      = "WORDPRESS_DB_HOST"
          valueFrom = aws_ssm_parameter.db_host.arn
        },
        {
          name      = "WORDPRESS_DB_USER"
          valueFrom = aws_ssm_parameter.db_user.arn
        },
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = aws_ssm_parameter.db_pass.arn
        },
        {
          name      = "WORDPRESS_DB_NAME"
          valueFrom = aws_ssm_parameter.db.arn
        },
        {
          name      = "WP_AUTH_KEY"
          valueFrom = aws_ssm_parameter.wp_auth_key.arn
        },
        {
          name      = "WP_SECURE_AUTH_KEY"
          valueFrom = aws_ssm_parameter.wp_secure_auth_key.arn
        },
        {
          name      = "WP_LOGGED_IN_KEY"
          valueFrom = aws_ssm_parameter.wp_logged_in_key.arn
        },
        {
          name      = "WP_NONCE_KEY"
          valueFrom = aws_ssm_parameter.wp_nonce_key.arn
        },
        {
          name      = "WP_AUTH_SALT"
          valueFrom = aws_ssm_parameter.wp_auth_salt.arn
        },
        {
          name      = "WP_SECURE_AUTH_SALT"
          valueFrom = aws_ssm_parameter.wp_secure_auth_salt.arn
        },
        {
          name      = "WP_LOGGED_IN_SALT"
          valueFrom = aws_ssm_parameter.wp_logged_in_salt.arn
        },
        {
          name      = "WP_NONCE_SALT"
          valueFrom = aws_ssm_parameter.wp_nonce_salt.arn
        }
      ],
      environment = [
        {
          name = "WORDPRESS_TABLE_PREFIX"
          value = "wp"
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
      file_system_id     = aws_efs_file_system.battlemaps.id
      root_directory     = "/"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.battlemaps-themes.id
      }
    }
  }
  volume {
    name = "battlemaps-efs-plugins"

    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.battlemaps.id
      root_directory     = "/"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.battlemaps-plugins.id
      }
    }
  }
  volume {
    name = "battlemaps-efs-uploads"

    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.battlemaps.id
      root_directory     = "/"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.battlemaps-uploads.id
      }
    }
  }
}