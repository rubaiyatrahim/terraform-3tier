output "db_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_secret_arn" {
  description = "The ARN of the secret in Secrets Manager containing the DB password"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}