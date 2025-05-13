terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}


variable "env" {
  type = string
  default = "dev"
}

variable "region" {
  type = string
  default = "us-west-1"
}

variable "project" {
  type = string
}

variable "company" {
  type = string
  default = "company"
}
