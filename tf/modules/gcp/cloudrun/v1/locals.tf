locals {
  service_account_name = "${var.env}-${var.region}-${var.service_name}"
  container_image = "{var.env}-${var.region}-${var.tag}"
}
