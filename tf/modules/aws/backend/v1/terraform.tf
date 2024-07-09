
locals {
    path = "terraform/${locals.env}/${locals.env}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "ch-tlc-state"
    key = locals.path
    region = "us-west-1"
  }
}


