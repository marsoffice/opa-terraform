variable "location" {
  type = string
}

variable "env" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "app_name" {
  type = string
}

variable "short_app_name" {
  type = string
}

variable "secrets" {
  type = map(string)
}

variable "is_main" {
  type = bool
}

variable "appi_retention" {
  type = number
}
variable "appi_sku" {
  type = string
}

variable "marsoffice_sa_connection_string" {
  type = string
}