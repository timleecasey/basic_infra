
module "vpc" {
  source = "../../../modules/aws/vpc/v1"
  env = "${var.env}"
  reg = "us-west-1"
  tag = "${var.env}-$var.tag}"
}

module "subnet" {
  source = "../../../modules/aws/subnet/v1"
  vpc_id = module.vpc.vpc_id
  cidr = "172.31.16.0/20"
  env = "${var.env}"
  reg = "us-west-1"
  tag = "${var.env}-$var.tag}"
}

module "sg" {
  source = "../../../modules/aws/sg/v1"
  vpc_id = module.vpc.vpc_id
  env = "${var.env}"
  reg = "us-west-1"
  tag = "${var.env}-$var.tag}"
}

