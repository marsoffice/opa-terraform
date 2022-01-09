variable "env" {
  type    = string
  default = "prod"
}

variable "app_name" {
  type    = string
  default = "opa"
}


variable "location" {
  type    = string
  default = "West Europe"
}

variable "opa_discovery_resource" {
  type = string
}

variable "opa_system_id" {
  type = string
  sensitive = true
}

variable "opa_service_token" {
  type = string
  sensitive = true
}

variable "opa_service_url" {
  type = string
  sensitive = true
}

variable "opa_bundles_service_url" {
  type = string
  sensitive = true
}
