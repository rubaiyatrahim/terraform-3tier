resource "aws_db_subnet_group" "main" {
  name       = "novacart-${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids
  tags       = { Name = "novacart-${var.environment}-db-subnet-group" }
}

resource "aws_db_instance" "main" {
  identifier           = "novacart-${var.environment}-db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]

  # Security & Credentials
  storage_encrypted           = true
  publicly_accessible         = false
  manage_master_user_password = true
  username                    = "admin"

  # Environment toggles
  multi_az                = var.multi_az
  deletion_protection     = var.deletion_protection
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
}