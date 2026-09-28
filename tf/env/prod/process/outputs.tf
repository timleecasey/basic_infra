output "function_url" {
  description = "HTTPS endpoint of the process-api"
  value       = module.lambda.function_url
}

output "bootstrap_key" {
  description = "The first api key the service accepts"
  value       = random_password.bootstrap_key.result
  sensitive   = true
}

output "backup_bucket" {
  description = "Bucket holding the nightly <name>.sql.gz backups (90-day expiry)"
  value       = module.backup_bucket.bucket
}

output "backup_function_name" {
  description = "The backup Lambda; invoke it to take a backup now"
  value       = module.backup.function_name
}

output "db_address" {
  description = "Hostname of the process database (inside the VPC)"
  value       = module.db.address
}
