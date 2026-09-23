output "function_name" {
  description = "Name of the function"
  value       = aws_lambda_function.function_def.function_name
}

output "function_arn" {
  description = "ARN of the function"
  value       = aws_lambda_function.function_def.arn
}

output "function_url" {
  description = "HTTPS URL of the function, null when function_url is false"
  value       = try(aws_lambda_function_url.url[0].function_url, null)
}

output "role_arn" {
  description = "ARN of the function's execution role"
  value       = aws_iam_role.lambda_role.arn
}
