output "vpc_id" {
  description = "The id of the VPC"
  value       = aws_vpc.this.id
}

output "cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "main_route_table_id" {
  description = "The VPC's main route table, used by every subnet without its own"
  value       = aws_vpc.this.main_route_table_id
}
