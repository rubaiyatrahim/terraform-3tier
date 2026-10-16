# ------------------------------------------------------------------------------
# 1. ALB Security Group (Internet Facing)
# ------------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "novacart-${var.environment}-alb-sg"
  description = "Allow HTTP inbound from anywhere"
  vpc_id      = var.vpc_id
  tags        = { Name = "novacart-${var.environment}-alb-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_allow_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ------------------------------------------------------------------------------
# 2. Bastion Security Group
# ------------------------------------------------------------------------------
resource "aws_security_group" "bastion" {
  name        = "novacart-${var.environment}-bastion-sg"
  description = "Allow SSH inbound from authorized IP"
  vpc_id      = var.vpc_id
  tags        = { Name = "novacart-${var.environment}-bastion-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = var.allowed_ssh_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "bastion_allow_all" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ------------------------------------------------------------------------------
# 3. App Servers Security Group (Private Tier)
# ------------------------------------------------------------------------------
resource "aws_security_group" "app" {
  name        = "novacart-${var.environment}-app-sg"
  description = "Allow HTTP from ALB and SSH from Bastion"
  vpc_id      = var.vpc_id
  tags        = { Name = "novacart-${var.environment}-app-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "app_http_from_alb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_bastion" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "app_allow_all" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ------------------------------------------------------------------------------
# 4. Database Security Group (Data Tier)
# ------------------------------------------------------------------------------
resource "aws_security_group" "db" {
  name        = "novacart-${var.environment}-db-sg"
  description = "Allow MySQL inbound only from App SG"
  vpc_id      = var.vpc_id
  tags        = { Name = "novacart-${var.environment}-db-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "db_mysql_from_app" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "db_allow_all" {
  security_group_id = aws_security_group.db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}