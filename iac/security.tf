resource "aws_security_group" "nat_egress" {
  name        = "nat-egress-allowed"
  description = "Allows egress through the DMZ NAT gateway"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "nat-egress-allowed"
  }
}

resource "aws_security_group_rule" "http_egress" {
  type              = "egress"
  description       = "Allow http egress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_egress.id
}
resource "aws_security_group_rule" "https_egress" {
  type              = "egress"
  description       = "Allow https egress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_egress.id
}

# ======= Containers SG ====

resource "aws_security_group" "battlemaps_service" {
  name        = "battlemaps-service-sg"
  description = "Controls access to the battlemaps tasks on ECS"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "battlemaps-service-sg"
  }
}

resource "aws_security_group_rule" "battlemaps_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.battlemaps_service.id
  description       = "Allow ingress from VPC"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
}
resource "aws_security_group_rule" "battlemaps_efs_engress" {
  type                     = "egress"
  security_group_id        = aws_security_group.battlemaps_service.id
  description              = "Allow EFS egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.efs_sg.id
}

resource "aws_security_group_rule" "battlemaps_db_engress" {
  type                     = "egress"
  security_group_id        = aws_security_group.battlemaps_service.id
  description              = "Allow DB Egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.db.id
}

# ====== EFS SG ====
resource "aws_security_group" "efs_sg" {
  name        = "battlemaps-efs-sg"
  description = "Controls Access to Battlemaps EFS"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "battlemaps-efs"
  }
}

resource "aws_security_group_rule" "vpc_efs_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.efs_sg.id
  from_port         = 2049
  to_port           = 2049
  protocol          = "TCP"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
}
resource "aws_security_group_rule" "vpc_efs_egress" {
  type              = "egress"
  security_group_id = aws_security_group.efs_sg.id
  from_port         = 2049
  to_port           = 2049
  protocol          = "TCP"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
}
# ====== RDS sgs ====
resource "aws_security_group" "db" {
  name        = "orion-rds-sg"
  description = "Controls Access to the Orion RDS instance"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "orion-rds-sg"
  }
}
resource "aws_security_group_rule" "db_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.db.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.battlemaps_service.id
}
resource "aws_security_group_rule" "db_dmz_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.db.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.dmz.id
}