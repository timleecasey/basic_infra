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
  description = "Name of the unit this VPC serves."
  type        = string
}

variable "cidr" {
  description = "CIDR block of the VPC."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply."
  type        = map(string)
  default     = {}
}
