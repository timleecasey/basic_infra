


module "lambda" {
  source = "../../../modules/aws/lambda/v1"
  env = "${var.env}"
  gin_mode = "debug"
  reg = "${var.reg}"
  shreg = "${var.shreg}"
  tag = "${var.tag}"
}


