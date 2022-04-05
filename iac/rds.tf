resource "aws_db_instance" "main" {
  allocated_storage = 10
  engine = "mariadb"
  engine_version = "10.6.7"
  instance_class = "db.t3.micro"
  name = "orion"
  username = "root"
  identifier = "orion"
  password = var.rds_root_password
  vpc_security_group_ids = [
      aws_security_group.db.id
  ]
  db_subnet_group_name = aws_db_subnet_group.main.name
  backup_retention_period = 14
  backup_window = "04:00-06:00"
  maintenance_window = "Mon:00:00-Mon:02:30"
}

resource "aws_db_subnet_group" "main" {
    name = "orion-subnet-group"
    subnet_ids = aws_subnet.private.*.id
    tags = {
        Name = "orion-subnet-group"
    }
}