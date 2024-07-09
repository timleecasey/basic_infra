variable "docker_tag" {
  type    = string
  default = "latest"
}

variable "env" {
  type    = string
}

variable "gin_mode" {
  type = string
  default = "release"
  description = "The debug mode for gin within a go executable"
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


