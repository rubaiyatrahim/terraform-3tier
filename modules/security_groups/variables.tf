variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where security groups will be created"
}

variable "environment" {
  type        = string
  description = "Environment name (dev or prod)"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH into the bastion host (e.g., your local IP/32)"
}