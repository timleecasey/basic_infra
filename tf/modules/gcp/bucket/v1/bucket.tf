
resource "google_storage_bucket" "this" {
  name                        = local.bucket_name
  location                    = var.region
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.uniform_bucket_level_access
  force_destroy               = var.force_destroy
  project                     = var.project
  encryption {
    default_kms_key_name =
  }
  retention_policy {
    retention_period = 0
  }

  versioning {
    enabled = var.versioning
  }

  labels = merge(
    var.labels,
    {
      env     = var.env
      project = var.project
    }
  )

#  dynamic "lifecycle_rule" {
#    for_each = var.archival ? [1] : []
#    content {
#      condition {
#        age = var.archival_days
#      }
#      action {
#        type          = "SetStorageClass"
#        storage_class = var.archival_storage_class
#      }
#    }
#  }
}
