variable "environment" { type = string }
variable "database_subnet_ids" { type = list(string) }
variable "db_sg_id" { type = string }

variable "multi_az" { type = bool }
variable "deletion_protection" { type = bool }
variable "backup_retention_period" { type = number }
variable "skip_final_snapshot" { type = bool }