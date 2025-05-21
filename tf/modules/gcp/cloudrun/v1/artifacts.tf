resource "google_artifact_registry_repository" "this" {
  location      = var.region
  repository_id = "${var.env}-${var.region}-${var.tag}"
  description   = "Docker repository for ${var.tag}"
  format        = "DOCKER"

  cleanup_policy_dry_run = false

  cleanup_policies {
    id     = "delete-untagged"
    action = "DELETE"
    condition {
      tag_state    = "UNTAGGED"
    }
  }

  cleanup_policies {
    id     = "keep-new-untagged"
    action = "KEEP"
    condition {
      tag_state    = "UNTAGGED"
      newer_than   = "7d"
    }
  }

  cleanup_policies {
    id     = "keep-tagged-release"
    action = "KEEP"
    condition {
      tag_state             = "TAGGED"
      tag_prefixes          = ["release"]
      package_name_prefixes = [var.tag]
    }
  }
}