variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones to use"
}

variable "single_nat_gateway" {
  type        = bool
  description = "If true, creates only one NAT Gateway for all private subnets. If false, creates one per AZ."
  default     = true
}

variable "environment" {
  type        = string
  description = "Environment name (dev or prod)"
}
