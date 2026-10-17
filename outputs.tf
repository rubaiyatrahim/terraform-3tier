output "alb_dns_name" {
  description = "The DNS name of the Load Balancer"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}
output "rds_secret_arn" {
  value = module.rds.db_secret_arn
}