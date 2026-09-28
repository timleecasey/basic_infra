variable "env" {
  description = "Deployment environment: dev, demo or prod"
  type        = string
  validation {
    condition     = contains(["dev", "prod", "demo"], var.env)
    error_message = "environment must be either \"demo\", \"dev\" or \"prod\""
  }
}

variable "reg" {
  description = "AWS region, e.g. us-west-1."
  type        = string
  default     = "us-west-1"
}

variable "shreg" {
  description = "Used for naming to produce a name in fewer characters.  Assumed to be the standard short names for a region."
  type        = string
  default     = "usw1"
}

variable "tag" {
  description = "Name of the unit the function runs."
  type        = string
}

variable "image_uri" {
  description = "Container image to run, <ecr repository url>:<tag>."
  type        = string
}

variable "env_vars" {
  description = "Map of environment variables to set in the function."
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "Function timeout in seconds."
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Function memory in MB."
  type        = number
  default     = 256
}

variable "architectures" {
  description = "Instruction set of the image: x86_64 or arm64."
  type        = list(string)
  default     = ["x86_64"]
}

variable "subnet_ids" {
  description = "Subnets to attach the function to. Empty runs it outside any VPC."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security groups for the function's VPC attachment."
  type        = list(string)
  default     = []
}

variable "function_url" {
  description = "Expose the function over a Lambda function URL (HTTPS)."
  type        = bool
  default     = false
}

variable "function_url_auth_type" {
  description = "Function URL auth: NONE (the app authenticates) or AWS_IAM."
  type        = string
  default     = "AWS_IAM"
  validation {
    condition     = contains(["NONE", "AWS_IAM"], var.function_url_auth_type)
    error_message = "function_url_auth_type must be NONE or AWS_IAM"
  }
}

variable "policy_statements" {
  description = "Extra permissions for the function's role, each an Allow of actions on resources."
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}

variable "log_retention_days" {
  description = "Days to keep the function's CloudWatch logs."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags to apply."
  type        = map(string)
  default     = {}
}
