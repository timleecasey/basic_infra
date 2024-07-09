variable "env" {
  type    = string
}

variable "force" {
  type    = bool
  default = false
  description = "Will allow a force delete if set to true, removing repo and images."
}

variable "reg" {
  type    = string
  default = "us-west-1"
}

variable "shreg" {
  description = "Used for naming to produce a name in fewer characters.  Assumed to be the standard short names for a region."
  type    = string
  default = "usw1"
}

variable "tag" {
  type    = string
}


