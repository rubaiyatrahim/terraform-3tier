variable "environment" { type = string }
variable "app_sg_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "target_group_arn" { type = string }

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "asg_min_size" { type = number }
variable "asg_max_size" { type = number }
variable "asg_desired_capacity" { type = number }
