resource "aws_efs_file_system" "battlemaps" {
  creation_token = "battlemaps"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  tags = {
    Name = "Battlemaps"
    App  = "Battlemaps"
  }
}

resource "aws_efs_mount_target" "battlemaps" {
  count          = length(aws_subnet.private)
  file_system_id = aws_efs_file_system.battlemaps.id
  subnet_id      = aws_subnet.private[count.index].id
  security_groups = [
    aws_security_group.efs_sg.id
  ]
}

resource "aws_efs_access_point" "battlemaps-plugins" {
  file_system_id = aws_efs_file_system.battlemaps.id
  posix_user {
    gid = 33
    uid = 33
  }
  root_directory {
    path = "/plugins"
    creation_info {
      owner_gid   = 33
      owner_uid   = 33
      permissions = 660
    }
  }
}
resource "aws_efs_access_point" "battlemaps-themes" {
  file_system_id = aws_efs_file_system.battlemaps.id
  posix_user {
    gid = 33
    uid = 33
  }
  root_directory {
    path = "/themes"
    creation_info {
      owner_gid   = 33
      owner_uid   = 33
      permissions = 660
    }
  }
}
resource "aws_efs_access_point" "battlemaps-uploads" {
  file_system_id = aws_efs_file_system.battlemaps.id
  posix_user {
    gid = 33
    uid = 33
  }
  root_directory {
    path = "/uploads"
    creation_info {
      owner_gid   = 33
      owner_uid   = 33
      permissions = 660
    }
  }
}