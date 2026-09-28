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
  description = "Name of the unit the endpoint serves."
  type        = string
}

variable "vpc_id" {
  description = "VPC the endpoint belongs to."
  type        = string
}

variable "service" {
  description = "Gateway service: s3 or dynamodb."
  type        = string
  validation {
    condition     = contains(["s3", "dynamodb"], var.service)
    error_message = "service must be s3 or dynamodb (the gateway-endpoint services)"
  }
}

variable "route_table_ids" {
  description = "Route tables that get a route to the service through the endpoint."
  type        = list(string)
}

variable "policy" {
  description = "Endpoint policy (JSON). null allows full access to the service."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply."
  type        = map(string)
  default     = {}
}
