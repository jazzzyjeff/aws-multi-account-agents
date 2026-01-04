variable "service" {
  type = string
}

variable "region" {
  type = string
}

variable "ado" {
  type = map(string)
}

variable "spoke_account_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "create_security_group" {
  type     = bool
  default  = true
  nullable = false
}

variable "build_context" {
  type = string
}
