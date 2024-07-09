resource "aws_subnet" "segment" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr
  map_public_ip_on_launch = true
}

variable cidr {
    type = string
}

variable env {
    type = string
}

variable reg {
    type = string
    default = "us-west-1"
}

variable tag {
    type = string
}

variable vpc_id {
    type = string
}
