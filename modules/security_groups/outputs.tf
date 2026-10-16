output "alb_sg_id" {
  description = "Security Group ID for the ALB"
  value       = aws_security_group.alb.id
}

output "app_sg_id" {
  description = "Security Group ID for the App Servers"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "Security Group ID for the Database"
  value       = aws_security_group.db.id
}

output "bastion_sg_id" {
  description = "Security Group ID for the Bastion Host"
  value       = aws_security_group.bastion.id
}