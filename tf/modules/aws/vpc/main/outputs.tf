output "vpc_id" {
  description = "The id of the VPC"
  value       = aws_vpc.this.id
}

output "cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}
