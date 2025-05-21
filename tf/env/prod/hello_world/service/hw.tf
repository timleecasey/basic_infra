


module "hw" {
  source               = "../../../../modules/gcp/cloudrun/v1"
  tag                  = var.tag
  env                  = var.env
  project_id           = var.project_id
  region               = var.region
  port                 = "8080"

  env_vars = {
    BUCKET_NAME       = var.bucket_name
    DB_CONNECTION_URI = var.db_connection
  }

  ingress              = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  allow_unauthenticated = false

  invoker_principals   = [
    "serviceAccount:${module.proxy.sa_email}"
  ]
}

module "proxy" {
  source               = "../../../../modules/gcp/cloudrun/v1"
  tag                  = "proxy"
  env                  = var.env
  project_id           = var.project_id
  region               = var.region
  port                = "443"

  env_vars = {
    DME_URL = module.hw.url
  }

  ingress              = "INGRESS_TRAFFIC_ALL"
  allow_unauthenticated = true
}
