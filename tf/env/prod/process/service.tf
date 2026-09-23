
# The repository is declared in env/prod/ecr; the image must be pushed there
# before this env is applied.
data "aws_ecr_repository" "process" {
  name = "${var.env}-${var.shreg}-${var.tag}"
}

# The first api key the service accepts. Read it with
#   terraform output -raw bootstrap_key
resource "random_password" "bootstrap_key" {
  length  = 40
  special = false
}

module "lambda" {
  source             = "../../../modules/aws/lambda/main"
  env                = var.env
  reg                = var.reg
  shreg              = var.shreg
  tag                = var.tag
  image_uri          = "${data.aws_ecr_repository.process.repository_url}:${var.image_tag}"
  subnet_ids         = [module.subnet_a.subnet_id, module.subnet_b.subnet_id]
  security_group_ids = [module.sg_service.sg_id]

  function_url           = true
  function_url_auth_type = "NONE"

  env_vars = {
    PROCESS_DB                = "postgres"
    PROCESS_DB_DSN            = module.db.dsn
    PROCESS_BOOTSTRAP_COMPANY = var.bootstrap_company
    PROCESS_BOOTSTRAP_USER    = var.bootstrap_user
    PROCESS_BOOTSTRAP_KEY     = random_password.bootstrap_key.result
  }
}
