


module "chapi" {
  source = "../../../modules/aws/ecr/main"
  env    = var.env
  tag    = var.tag

  # l-prod-chapi runs an untagged digest (latest was re-pushed after deploy);
  # expiring untagged images would delete the image it runs.
  expire_untagged = false
}

module "process" {
  source = "../../../modules/aws/ecr/main"
  env    = var.env
  tag    = "process"
}

output "process_repository_url" {
  description = "Push process-api images here"
  value       = module.process.repository_url
}

