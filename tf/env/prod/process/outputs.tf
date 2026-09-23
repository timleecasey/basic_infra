output "function_url" {
  description = "HTTPS endpoint of the process-api"
  value       = module.lambda.function_url
}

output "bootstrap_key" {
  description = "The first api key the service accepts"
  value       = random_password.bootstrap_key.result
  sensitive   = true
}

output "db_address" {
  description = "Hostname of the process database (inside the VPC)"
  value       = module.db.address
}
