locals {
  service_account_name = "${var.env}-${var.region}-${var.tag}"
  container_image = "${var.env}-${var.region}-${var.tag}"

  labels = merge(
    var.labels,
    {
      env     = var.env
      project = var.project
      service = var.tag
    }
  )
  env = merge([
    for k, v in var.env_vars :
    {
      name  = k
      value = v
    }
  ],[
    {
      name  = "env"
      value = var.env
    },
    {
      name  = "tag"
      value = var.tag
    },
    {
      name  = "region"
      value = var.region
    }
  ])

}
