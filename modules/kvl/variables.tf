variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "secrets" {
  type = map(any)
}

variable "allowed_principals" {
  type = map(string)
}
