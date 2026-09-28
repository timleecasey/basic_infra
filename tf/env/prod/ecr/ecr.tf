


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

module "process_backup" {
  source = "../../../modules/aws/ecr/main"
  env    = var.env
  tag    = "process-backup"
}

output "process_repository_url" {
  description = "Push process-api images here"
  value       = module.process.repository_url
}

output "process_backup_repository_url" {
  description = "Push process-backup images here"
  value       = module.process_backup.repository_url
}

