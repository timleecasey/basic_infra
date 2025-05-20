variable "project_id" {
  description = "GCP project to deploy into"
  type        = string
}

variable "region" {
  description = "GCP region for Cloud Run"
  type        = string
  default     = "us-central1"
}

variable "account" {
  description = "Account for service."
  type = string
  required = true
}

variable "tag" {
  description = "Name for the Cloud Run service"
  type        = string
}

variable "env" {
  description = "Deployment environment: dev or prod"
  type        = string
  validation {
    condition     = contains(["dev", "prod", "demo"], var.env)
    error_message = "environment must be either \"demo\", \"dev\" or \"prod\""
  }
}

variable "ingress" {
  description = <<-EOT
    Network ingress setting for Cloud Run.
    Uses the Cloud Run annotation `run.googleapis.com/ingress`.
    Valid values (per API): `"all"`, `"internal-only"`, `"internal-and-cloud-load-balancing"`.
    See docs :contentReference[oaicite:0]{index=0}.
  EOT
  type = string
  default = "all"
}

variable "allow_unauthenticated" {
  description = "If true, grant `roles/run.invoker` to allUsers at the service level"
  type        = bool
  default     = false
}


variable "project" {
  type        = string
  description = "GCP project ID"
}

variable "labels" {
  description = "Additional labels to apply to the bucket."
  type        = map(string)
  default     = {}
  required = false
}
