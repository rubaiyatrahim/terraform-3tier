# Fetch available Availability Zones dynamically
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  # Slice the first two AZs to fulfill the 2 AZ requirement
  azs                = slice(data.aws_availability_zones.available.names, 0, 2)
  
  # For dev, we use 1 NAT. For prod, we use 1 per AZ.
  single_nat_gateway = var.environment == "dev" ? true : false
}