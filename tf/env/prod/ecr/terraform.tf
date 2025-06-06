
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "ch-tlc-state"
    key = "terraform/prod/us-west-1/ecr"
    region = "us-west-1"
  }
}


variable "env" {
    type = string
    default = "prod"
}

variable "tag" {
    type = string
    default = "chapi"
}

