


module "chapi" {
  source = "../../../modules/aws/ecr/v1"
  env = "${var.env}"
  reg = "${var.reg}"
  shreg = "${var.shreg}"
  tag = "${var.tag}"
}


