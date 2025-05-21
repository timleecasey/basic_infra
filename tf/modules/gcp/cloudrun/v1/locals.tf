locals {
  service_account_name = "${var.env}-${var.region}-${var.tag}"
  container_image = "${var.env}-${var.region}-${var.tag}"

  labels = merge(
    var.labels,
    {
      "env"     = var.env
      "pid"     = var.project_id
      "service" = var.tag
    }
  )
  std_env = {
    "env" = var.env,
    "tag" = var.tag,
    "region" = var.region
  }

  full_env_list = merge(local.std_env, var.env_vars)

  env_list = [
    for k,v in local.full_env_list : {
      name = k
      value = v
    }
  ]

}
