variable "env" {
  description = "Deployment environment: dev, demo or prod"
  type        = string
  validation {
    condition     = contains(["dev", "prod", "demo"], var.env)
    error_message = "environment must be either \"demo\", \"dev\" or \"prod\""
  }
}

variable "shreg" {
  description = "Short region name used in resource names, e.g. usw1."
  type        = string
  default     = "usw1"
}

variable "tag" {
  description = "Name of the unit the schedule runs."
  type        = string
}

variable "schedule_expression" {
  description = "When to run: cron(...), rate(...) or at(...), e.g. \"cron(0 2 * * ? *)\"."
  type        = string
}

variable "timezone" {
  description = "IANA time zone the schedule expression is read in."
  type        = string
  default     = "UTC"
}

variable "function_arn" {
  description = "ARN of the Lambda function the schedule invokes."
  type        = string
}

variable "input" {
  description = "JSON event the function receives."
  type        = string
  default     = "{}"
}

variable "tags" {
  description = "Additional tags to apply."
  type        = map(string)
  default     = {}
}
