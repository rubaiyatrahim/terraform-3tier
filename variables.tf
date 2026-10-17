variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "novacart"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev or prod)"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment must be strictly 'dev' or 'prod'."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the entire VPC"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH into the bastion host"
}
variable "asg_min_size" { default = 1 }
variable "asg_max_size" { default = 2 }
variable "asg_desired_capacity" { default = 1 }
variable "instance_type" { default = "t3.micro" }
# Defaulting to dev values for now
variable "rds_multi_az" { default = false }
variable "rds_deletion_protection" { default = false }
variable "rds_backup_retention_period" { default = 0 } # Changed to 0 to fix Free Tier error
variable "rds_skip_final_snapshot" { default = true }