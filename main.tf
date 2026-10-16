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