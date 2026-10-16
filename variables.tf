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