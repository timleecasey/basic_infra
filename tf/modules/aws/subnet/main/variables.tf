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
  description = "Name of this subnet, e.g. process-a."
  type        = string
}

variable "vpc_id" {
  description = "The VPC the subnet belongs to."
  type        = string
}

variable "cidr" {
  description = "CIDR block of the subnet, inside the VPC CIDR."
  type        = string
}

variable "availability_zone" {
  description = "Availability zone of the subnet, e.g. us-west-1a."
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Whether instances launched in the subnet get a public IP."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply."
  type        = map(string)
  default     = {}
}
