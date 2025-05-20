terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
      project = var.project_id
      region  = var.region
    },
    google-beta = {
      source = "hashicorp/google-beta"
      project = var.project_id
      region  = var.region
    }

  }

  backend "gcs" {
    bucket = "${var.company}-${var.env}-state"
    key = "terraform/${var.env}/${var.region}${var.project}/${var.tag}"
    region = "us-west-1"
  }

}

variable "bucket_name"    {
  type = string
}
variable "db_connection"  {
  type = string
}

