# aws_lambda_permission.invoked_via_function_url needs the 6.x provider.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}
