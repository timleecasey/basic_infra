
variable company {
  description = "The company name used for namespace of the bucket.  This is used to differentiate the name space of all buckets."
  type = string
  required = true
}

variable group {
  description = "The Group the bucket is assigned to.   This is used to differentiate the name space of all buckets."
  type = string
  required = true
}

variable "project_id" {
  description = "GCP project ID in which to create the bucket.  This is used to differentiate the name space of all buckets."
  type = string
  required = true

  validation {
    condition     = length(var.project_id) > 0
    error_message = "A non‑empty project ID must be provided."
  }
}

variable "env" {
  description = "Environment tag.  This is used to differentiate the name space of all buckets."
  type        = string
  default     = "dev"
  required = true

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "env must be one of [\"dev\", \"prod\"]."
  }
}

variable "region" {
  description = "GCS bucket location (e.g. US, US-CENTRAL1, EU, EUROPE-WEST1, ASIA-EAST1)."
  type        = string
  default     = "US"
  required = true

  validation {
    condition     = length(var.region) > 0
    error_message = "region must be a non‑empty string."
  }
}

variable "storage_class" {
  description = "Storage class for new objects.  This is used to differentiate the name space of all buckets."
  type        = string
  default     = "STANDARD"
  required = false

  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "storage_class must be one of [\"STANDARD\", \"NEARLINE\", \"COLDLINE\", \"ARCHIVE\"]."
  }
}

variable "versioning" {
  description = "Enable object versioning."
  type        = bool
  default     = true
  required = false
}

variable "uniform_bucket_level_access" {
  description = "Enable Uniform Bucket‑Level Access (recommended)."
  type = bool
  default = true
  required = false
}

variable "force_destroy" {
  description = "If true, allow Terraform to delete non‑empty buckets."
  type = bool
  default = false
  required = false
}

variable "labels" {
  description = "Additional labels to apply to the bucket."
  type        = map(string)
  default     = {}
  required = false
}

#variable "archival" {
#  description = "Whether to add a lifecycle rule to transition objects to archival storage."
#  type        = bool
#  default     = false
#}

variable "archival_days" {
  description = "Number of days after object creation to transition to archival."
  type        = number
  default     = 90

  validation {
    condition     = var.archival_days >= 90
    error_message = "archival_days must be greater than 90."
  }
}

variable "archival_storage_class" {
  description = "Storage class to transition to when archiving."
  type        = string
  default     = "STANDARD"
  required = false

  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.archival_storage_class)
    error_message = "archival_storage_class must be one of [\"STANDARD\", \"NEARLINE\", \"COLDLINE\", \"ARCHIVE\"]."
  }
}
