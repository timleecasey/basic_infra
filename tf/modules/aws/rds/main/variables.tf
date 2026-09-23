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
  description = "Name of the unit this database serves."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the DB subnet group; RDS requires at least two availability zones."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to the instance."
  type        = list(string)
}

variable "engine_version" {
  description = "Postgres engine version; a major version (e.g. 16) takes the default minor."
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Storage in GiB."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the database created on the instance."
  type        = string
}

variable "username" {
  description = "Master username. The password is generated and exposed only as a sensitive output."
  type        = string
}

variable "backup_retention_period" {
  description = "Days of automated backups to keep."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Refuse to delete the instance while true."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply."
  type        = map(string)
  default     = {}
}
