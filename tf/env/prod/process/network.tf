
# RDS needs subnets in two availability zones.
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../../modules/aws/vpc/main"
  env    = var.env
  shreg  = var.shreg
  tag    = var.tag
  cidr   = var.vpc_cidr
}

module "subnet_a" {
  source            = "../../../modules/aws/subnet/main"
  env               = var.env
  shreg             = var.shreg
  tag               = "${var.tag}-a"
  vpc_id            = module.vpc.vpc_id
  cidr              = cidrsubnet(var.vpc_cidr, 8, 0)
  availability_zone = data.aws_availability_zones.available.names[0]
}

module "subnet_b" {
  source            = "../../../modules/aws/subnet/main"
  env               = var.env
  shreg             = var.shreg
  tag               = "${var.tag}-b"
  vpc_id            = module.vpc.vpc_id
  cidr              = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = data.aws_availability_zones.available.names[1]
}

# The function takes no inbound traffic in the VPC; it only calls out to the db.
module "sg_service" {
  source = "../../../modules/aws/sg/main"
  env    = var.env
  shreg  = var.shreg
  tag    = "${var.tag}-service"
  vpc_id = module.vpc.vpc_id
}

module "sg_db" {
  source = "../../../modules/aws/sg/main"
  env    = var.env
  shreg  = var.shreg
  tag    = "${var.tag}-db"
  vpc_id = module.vpc.vpc_id
  ingress = [{
    description     = "postgres from the service"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.sg_service.sg_id]
  }]
}
