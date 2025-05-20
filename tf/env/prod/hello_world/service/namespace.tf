
#
# This is here to be explicit
# It is more direct to put the variable inside
# the modules, without going through a tfvars
# and variable declaration.
#

variable "env" {
  type = string
}

variable "tag" {
  type = string
}

variable "region" {
  type = string
}

variable "project" {
  type = string
}

variable "company" {
  type = string
}

variable "project_id" {
  type = string
}

variable "service_name" {
  type = string
}
