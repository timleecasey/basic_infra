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
  description = "Name of this security group, e.g. process-db."
  type        = string
}

variable "vpc_id" {
  description = "The VPC the security group belongs to."
  type        = string
}

variable "ingress" {
  description = <<-EOF
    Ingress rules. Each opens from_port..to_port over protocol to the given
    CIDR blocks and/or source security groups. Empty means no inbound traffic.
    EOF
  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))
  default = []
}

variable "tags" {
  description = "Additional tags to apply."
  type        = map(string)
  default     = {}
}
