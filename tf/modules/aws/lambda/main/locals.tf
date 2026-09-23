locals {
  function_name = "l-${var.env}-${var.tag}"
  in_vpc        = length(var.subnet_ids) > 0

  tags = merge(
    var.tags,
    {
      env  = var.env
      reg  = var.shreg
      unit = var.tag
    }
  )

  std_env = {
    "env"    = var.env
    "tag"    = var.tag
    "region" = var.reg
  }

  env_vars = merge(local.std_env, var.env_vars)
}
