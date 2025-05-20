
resource "google_cloud_run_v2_service" "this" {
  provider = google-beta
  name     = "${var.env}-${var.region}-${var.tag}"
  location = var.region
  project  = var.project_id

  labels = local.labels

  template {
    service_account = google_service_account.sa.email

    containers {
      image = local.container_image
      env = local.env
    }
  }

  ingress = var.ingress

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Grant invoker rights
resource "google_cloud_run_v2_service_iam_member" "invoker" {
  for_each = toset(
    var.allow_unauthenticated
    ? ["allUsers"]
    : var.invoker_principals
  )

  provider = google-beta
  service  = google_cloud_run_v2_service.this.name
  location = google_cloud_run_v2_service.this.location
  project  = google_cloud_run_v2_service.this.project
  role     = "roles/run.invoker"
  member   = each.value
}
