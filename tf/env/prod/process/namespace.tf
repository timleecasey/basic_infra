
#
# This is here to be explicit
# It is more direct to put the variable inside
# the modules, without going through a tfvars
# and variable declaration.
#

variable "env" {
  type = string
}

variable "reg" {
  type = string
}

variable "shreg" {
  type = string
}

variable "tag" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "backup_image_tag" {
  type = string
}

variable "bootstrap_company" {
  type = string
}

variable "bootstrap_user" {
  type = string
}
