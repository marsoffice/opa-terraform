variable "env" {
  type    = string
  default = "stg"
}

variable "app_name" {
  type    = string
  default = "marsoffice"
}

variable "short_app_name" {
  type    = string
  default = "moc"
}


variable "resource_group" {
  type    = string
  default = "rg-marsoffice"
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
