module "hw_network" {
  source = "../../../../modules/gcp/iap/v1"
  env = "${var.env}"
  tag = "${var.tag}"
  project = "tlc-demo-gcp"
  project_id = "859479185776"
  service_name = "hw"
  account = "abc"
}
