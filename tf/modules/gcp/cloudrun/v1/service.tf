
resource "google_cloud_run_v2_service" "this" {
  provider = google-beta
  name     = "${var.env}-${var.region}-${var.tag}"
  location = var.region
  project  = var.project_id
  ingress = var.ingress

  labels = local.labels

  template {
    scaling {
      min_instance_count = 1
      max_instance_count = 1
    }
    service_account = google_service_account.sa.email

    containers {
      name = "${var.env}-${var.region}-${var.tag}"
      image = local.container_image

      env {
        name = "env"
        value = var.env
      }
      ports {
        container_port = var.port
      }

      liveness_probe {
        http_get {
          path = "/"
        }
      }

      startup_probe {
        initial_delay_seconds = 5
        timeout_seconds = 5
        period_seconds = 5
        failure_threshold = 15
        tcp_socket {
          port = 8080
        }
      }

      #      for k,v in local.full_env_list : env {
#        name = k
#        value = v
#      }



    }


  }

}

# Grant invoker rights
resource "google_cloud_run_v2_service_iam_member" "invoker" {
  name = "${var.env}-${var.region}-${var.tag}-iam"
  for_each = toset(
    var.allow_unauthenticated
    ? ["allUsers"]
    : var.invoker_principals
  )

  provider = google-beta
  location = google_cloud_run_v2_service.this.location
  project  = google_cloud_run_v2_service.this.project
  role     = "roles/run.invoker"
  member   = each.value
}
