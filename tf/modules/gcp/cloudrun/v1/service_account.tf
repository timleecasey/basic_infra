resource "google_service_account" "this" {
  account_id   = var.account_id
  display_name = local.service_account_name
  project      = var.project
}
