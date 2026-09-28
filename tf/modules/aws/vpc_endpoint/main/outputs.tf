output "endpoint_id" {
  description = "ID of the endpoint"
  value       = aws_vpc_endpoint.this.id
}

output "prefix_list_id" {
  description = "Prefix list of the service's addresses, for security group rules"
  value       = aws_vpc_endpoint.this.prefix_list_id
}
