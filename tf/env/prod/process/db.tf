
module "db" {
  source             = "../../../modules/aws/rds/main"
  env                = var.env
  shreg              = var.shreg
  tag                = var.tag
  db_name            = "process"
  username           = "process"
  subnet_ids         = [module.subnet_a.subnet_id, module.subnet_b.subnet_id]
  security_group_ids = [module.sg_db.sg_id]
}
