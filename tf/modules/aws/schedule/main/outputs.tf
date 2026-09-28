output "schedule_arn" {
  description = "ARN of the schedule"
  value       = aws_scheduler_schedule.this.arn
}

output "role_arn" {
  description = "ARN of the role the schedule invokes the function with"
  value       = aws_iam_role.scheduler.arn
}
