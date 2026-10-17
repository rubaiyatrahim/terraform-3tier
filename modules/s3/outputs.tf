output "bucket_name" {
  description = "The name of the secure S3 bucket"
  value       = aws_s3_bucket.main.id
}