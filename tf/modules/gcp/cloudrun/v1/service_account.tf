
resource "google_service_account" "sa" {
  account_id   = "${var.env}-${var.tag}-sa"
  display_name = local.service_account_name
  project      = var.project_id
}
