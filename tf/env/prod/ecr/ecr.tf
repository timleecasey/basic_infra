


module "chapi" {
  source = "../../../modules/aws/ecr/v1"
  env = "${var.env}"
  tag = "${var.tag}"
}


