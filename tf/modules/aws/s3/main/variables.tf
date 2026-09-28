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
  description = "Name of the unit whose objects the bucket holds."
  type        = string
}

variable "expire_days" {
  description = "Delete objects this many days after they are written. null keeps them."
  type        = number
  default     = null
  validation {
    condition     = var.expire_days == null || try(var.expire_days >= 1, false)
    error_message = "expire_days must be at least 1, or null"
  }
}

variable "force_destroy" {
  description = "Allow terraform destroy to delete a bucket that still holds objects."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply."
  type        = map(string)
  default     = {}
}
