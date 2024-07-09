
resource "aws_security_group" "sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  revoke_rules_on_delete = true
  description = "${var.tag} sg on vpc in ${var.reg} tagged ${var.tag}"
  name = "${var.env}-${var.reg}-${var.tag}"
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
