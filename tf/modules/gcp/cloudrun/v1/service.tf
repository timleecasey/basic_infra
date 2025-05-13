resource "google_cloud_run_service" "this" {
  name     = var.name
  project  = var.project
  location = var.region

  metadata {
    annotations = {
      # control network ingress
      "run.googleapis.com/ingress" = var.ingress
    }
    labels = merge(
      var.labels,
      {
        env     = var.env
        project = var.project
        service = var.service_name
      }
    )
  }


  template {
    spec {
      service_account_name = var.service_account_email

      containers {
        image = var.image

        env {
          name  = "ENV"
          value = var.environment
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "unauth" {
  count   = var.allow_unauthenticated ? 1 : 0
  project = var.project
  location = var.region
  service = google_cloud_run_service.this.name

  role   = "roles/run.invoker"
  member = "allUsers"
}
