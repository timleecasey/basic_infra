
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "ch-tlc-state"
    key = "terraform/prod/vpc"
    region = "us-west-1"
  }
}


variable "env" {
    type = string
    default = "prod"
}

variable "region" {
    type = string
    default = "us-west-1"
}

variable "tag" {
    type = string
    default = "vpc"
}

