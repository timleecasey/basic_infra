# basic_infra

A basic example of intrastructure.

tf: holds TF sources
  modules: holds the modules broken down by provider and module component within the provider and then versioned.
  env: holds the environment declarations, composed of modules

This allows you to build up a specific composed piece of infrastucture, composed of provider wrapped modules.

A simple declartion under env with a vpc + subnet with a security group to control access.
The terraform used to build the modules is under the modules.  If you need to create a different module, you use a different version.
Once a numbered version is created it is not modified so references will be stable and the resulting infrastructure will be stable once declared.  Versioned modules are released.

<code>
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
</code>
