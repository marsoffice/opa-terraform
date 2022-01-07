terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

module "appi" {
  source         = "../appi"
  location       = var.location
  name           = "appi-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  resource_group = var.resource_group
  retention      = var.appi_retention
  sku            = var.appi_sku
}

module "sa" {
  source           = "../sa"
  location         = var.location
  resource_group   = var.resource_group
  name             = "sa${var.short_app_name}${replace(lower(var.location), " ", "")}${var.env}"
  tier             = "Standard"
  replication_type = "LRS"
  access_tier      = "Hot"
}

module "kvl" {
  source         = "../kvl"
  location       = var.location
  resource_group = var.resource_group
  name           = "kvl-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  secrets = merge(var.secrets, tomap({
    localsaconnectionstring      = module.sa.connection_string,
    marsofficesaconnectionstring = var.marsoffice_sa_connection_string
  }))
}

module "appsp" {
  source         = "../appsp"
  location       = var.location
  resource_group = var.resource_group
  name           = "appsp-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
}

locals {
  commonsettings = merge(
    zipmap(keys(var.secrets), [for x in keys(var.secrets) : "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/${x}/)"]),
    tomap({
      ismain                       = var.is_main,
      location                     = var.location,
      localsaconnectionstring      = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/localsaconnectionstring/)",
      marsofficesaconnectionstring = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/marsofficesaconnectionstring/)",
    })
  )


}


module "func_opa" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-opa-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs                = local.commonsettings
  appi_instrumentation_key   = module.appi.instrumentation_key
  func_env                   = var.env == "stg" ? "Staging" : "Production"
  runtime                    = "custom"
}