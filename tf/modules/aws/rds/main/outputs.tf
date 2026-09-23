output "address" {
  description = "Hostname of the instance (resolvable inside the VPC)"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Port of the instance"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.this.db_name
}

output "username" {
  description = "Master username"
  value       = aws_db_instance.this.username
}

output "password" {
  description = "Generated master password"
  value       = random_password.master.result
  sensitive   = true
}

output "dsn" {
  description = "postgres:// connection string with TLS required"
  value       = "postgres://${aws_db_instance.this.username}:${random_password.master.result}@${aws_db_instance.this.address}:${aws_db_instance.this.port}/${aws_db_instance.this.db_name}?sslmode=require"
  sensitive   = true
}
