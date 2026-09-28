terraform {
  required_version = ">= 1.3"
}

data "aws_caller_identity" "current" {
}

# EventBridge Scheduler assumes this role to invoke the function; the condition
# keeps schedules in other accounts from using it.
resource "aws_iam_role" "scheduler" {
  name = "role-${local.name}-schedule"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "scheduler.amazonaws.com" }
      Condition = {
        StringEquals = { "aws:SourceAccount" = data.aws_caller_identity.current.account_id }
      }
    }]
  })
  tags = local.tags
}

resource "aws_iam_role_policy" "invoke" {
  name = "invoke"
  role = aws_iam_role.scheduler.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "lambda:InvokeFunction"
      Effect   = "Allow"
      Resource = var.function_arn
    }]
  })
}

# The schedule invokes the function asynchronously: a failed run is retried by
# Lambda's own async retries (two by default).
resource "aws_scheduler_schedule" "this" {
  name                         = local.name
  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = var.timezone

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.function_arn
    role_arn = aws_iam_role.scheduler.arn
    input    = var.input
  }
}
