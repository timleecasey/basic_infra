
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "ch-tlc-state"
    key    = "terraform/prod/us-west-1/process"
    region = "us-west-1"
  }
}

provider "aws" {
  region = var.reg
}
