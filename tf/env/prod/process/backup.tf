
# Nightly SQL backup of the process db: a scheduled Lambda (the cnc repo,
# svc/process/backup) runs pg_dump in the VPC and writes <name>.sql.gz to a
# private bucket that expires objects after 90 days.

module "backup_bucket" {
  source      = "../../../modules/aws/s3/main"
  env         = var.env
  shreg       = var.shreg
  tag         = "${var.tag}-backup"
  expire_days = 90
}

# The subnets have no internet route; S3 is reached through a gateway endpoint,
# whose policy limits that path to writing backups into the bucket.
module "s3_endpoint" {
  source          = "../../../modules/aws/vpc_endpoint/main"
  env             = var.env
  shreg           = var.shreg
  tag             = "${var.tag}-s3"
  vpc_id          = module.vpc.vpc_id
  service         = "s3"
  route_table_ids = [module.vpc.main_route_table_id]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:PutObject", "s3:AbortMultipartUpload"]
      Resource  = "${module.backup_bucket.bucket_arn}/*"
    }]
  })
}

# The repository is declared in env/prod/ecr; the image must be pushed there
# before this env is applied.
data "aws_ecr_repository" "backup" {
  name = "${var.env}-${var.shreg}-${var.tag}-backup"
}

# Uses the service security group: the db admits 5432 from it.
module "backup" {
  source             = "../../../modules/aws/lambda/main"
  env                = var.env
  reg                = var.reg
  shreg              = var.shreg
  tag                = "${var.tag}-backup"
  image_uri          = "${data.aws_ecr_repository.backup.repository_url}:${var.backup_image_tag}"
  subnet_ids         = [module.subnet_a.subnet_id, module.subnet_b.subnet_id]
  security_group_ids = [module.sg_service.sg_id]
  timeout            = 300
  memory_size        = 512

  policy_statements = [{
    actions   = ["s3:PutObject", "s3:AbortMultipartUpload"]
    resources = ["${module.backup_bucket.bucket_arn}/*"]
  }]

  env_vars = {
    PROCESS_DB_DSN = module.db.dsn
    BACKUP_DEST    = "s3://${module.backup_bucket.bucket}"
  }
}

module "backup_schedule" {
  source              = "../../../modules/aws/schedule/main"
  env                 = var.env
  shreg               = var.shreg
  tag                 = "${var.tag}-backup"
  schedule_expression = "cron(0 2 * * ? *)"
  timezone            = "America/Los_Angeles"
  function_arn        = module.backup.function_arn
}
