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
  description = "Name of the unit whose images the repository holds."
  type        = string
}

variable "force" {
  description = "Will allow a force delete if set to true, removing repo and images."
  type        = bool
  default     = false
}

variable "expire_untagged" {
  description = <<-EOF
    Expire untagged images after untagged_expire_days. Leave false for a repo whose
    function still runs an image that has lost its tag (re-pushed tag), or the
    running image is deleted.
    EOF
  type        = bool
  default     = true
}

variable "untagged_expire_days" {
  description = "Untagged images older than this many days are expired."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Additional tags to apply."
  type        = map(string)
  default     = {}
}
