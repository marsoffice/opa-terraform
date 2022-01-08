terraform {
  backend "azurerm" {
    resource_group_name  = "rg-marsoffice"
    storage_account_name = "samarsoffice"
    container_name       = "tfstates"
    key                  = "marsoffice.stg.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.85"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  secrets = tomap({
    opa_discovery_resource  = var.opa_discovery_resource,
    opa_system_id           = var.opa_system_id,
    opa_service_token       = var.opa_service_token,
    opa_service_url         = var.opa_service_url,
    opa_bundles_service_url = var.opa_bundles_service_url
  })
}




module "rg" {
  source   = "../modules/rg"
  name     = "rg-${var.app_name}-${var.env}"
  location = var.location
}

module "sa_marsoffice" {
  source         = "../modules/data-sa"
  name           = "samarsoffice"
  resource_group = "rg-marsoffice"
}


module "zone_westeurope" {
  source                          = "../modules/zone"
  location                        = "West Europe"
  resource_group                  = module.rg.name
  app_name                        = var.app_name
  short_app_name                  = var.short_app_name
  env                             = var.env
  secrets                         = local.secrets
  is_main                         = true
  appi_retention                  = 30
  appi_sku                        = "PerGB2018"
  marsoffice_sa_connection_string = module.sa_marsoffice.connection_string
}
