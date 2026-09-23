output "repository_url" {
  description = "Registry URL to tag and push images to"
  value       = aws_ecr_repository.repo.repository_url
}

output "repository_name" {
  description = "Name of the repository"
  value       = aws_ecr_repository.repo.name
}

output "repository_arn" {
  description = "ARN of the repository"
  value       = aws_ecr_repository.repo.arn
}
