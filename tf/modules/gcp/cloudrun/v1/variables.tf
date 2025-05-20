variable "project_id" {
  description = "GCP project id to deploy into"
  type        = string
}

variable "region" {
  description = "GCP region for Cloud Run"
  type        = string
  default     = "us-central1"
}

variable "tag" {
  description = "Name for the Cloud Run service"
  type        = string
}

variable "env" {
  description = "Deployment environment: dev, demo or prod"
  type        = string
  validation {
    condition     = contains(["dev", "prod", "demo"], var.env)
    error_message = "environment must be either \"demo\", \"dev\" or \"prod\""
  }
}

variable "labels" {
  description = "Additional labels to apply to the bucket."
  type        = map(string)
  default     = {}
  required = false
}


variable "env_vars" {
  type        = map(string)
  description = "Map of environment variables to set in the container."
  default     = {}
}

variable "ingress" {
  type        = string
  description = <<-EOF
    Ingress setting, one of:
      - INGRESS_TRAFFIC_ALL
      - INGRESS_TRAFFIC_INTERNAL_ONLY
      - INGRESS_TRAFFIC_INTERNAL_AND_LB
    EOF
  default     = "INGRESS_TRAFFIC_ALL"
  validation {
    condition = contains(
      ["INGRESS_TRAFFIC_ALL","INGRESS_TRAFFIC_INTERNAL_ONLY","INGRESS_TRAFFIC_INTERNAL_AND_LB"],
      var.ingress
    )
    error_message = "ingress must be one of the three supported INGRESS_TRAFFIC_* values"
  }
}

variable "allow_unauthenticated" {
  type        = bool
  description = "Whether to allow public (unauthenticated) access."
  default     = false
}

variable "invoker_principals" {
  type        = list(string)
  description = <<-EOF
    Additional IAM members to grant roles/run.invoker on this service,
    e.g. ["serviceAccount:my-proxy-sa@…"].
    Ignored if allow_unauthenticated = true.
    EOF
  default     = []
}

