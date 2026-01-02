variable "service" {
  type = string
}

variable "region" {
  type = string
}

variable "ado" {
  type = map(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "security_group" {
  type = string
}
