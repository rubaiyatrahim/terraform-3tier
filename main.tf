# Fetch available Availability Zones dynamically
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  # Slice the first two AZs to fulfill the 2 AZ requirement
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  # For dev, we use 1 NAT. For prod, we use 1 per AZ.
  single_nat_gateway = var.environment == "dev" ? true : false
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id           = module.vpc.vpc_id
  environment      = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidr
}
module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  environment       = var.environment
}

module "app" {
  source = "./modules/app"

  environment          = var.environment
  app_sg_id            = module.security_groups.app_sg_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  target_group_arn     = module.alb.target_group_arn
  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
  instance_type        = var.instance_type
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

module "rds" {
  source = "./modules/rds"

  environment             = var.environment
  database_subnet_ids     = module.vpc.database_subnet_ids
  db_sg_id                = module.security_groups.db_sg_id
  
  multi_az                = var.rds_multi_az
  deletion_protection     = var.rds_deletion_protection
  backup_retention_period = var.rds_backup_retention_period
  skip_final_snapshot     = var.rds_skip_final_snapshot
}