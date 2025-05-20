terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }

  backend "gcs" {
    bucket = "${var.company}-${var.env}-state"
    key = "terraform/${var.env}/${var.region}${var.project}/${var.tag}"
    region = "us-west-1"
  }

}

provider "google" {
  project = var.project
  region  = var.region
}

