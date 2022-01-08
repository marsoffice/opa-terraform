terraform {
  backend "azurerm" {
    resource_group_name  = "rg-marsoffice"
    storage_account_name = "samarsoffice"
    container_name       = "tfstates"
    key                  = "marsoffice.prod.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.85"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.14.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {

}

locals {
  secrets = tomap({
    opadiscoveryresource = var.opa_discovery_resource,
    opasystemid          = var.opa_system_id,
    opaservicetoken      = var.opa_service_token,
    opaserviceurl        = var.opa_service_url,
    opabundlesserviceurl = var.opa_bundles_service_url
  })
  configs = tomap({
    opaservicename        = "styra",
    opabundlesservicename = "styra-bundles"
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

module "graph_api_sp" {
  source             = "../modules/data-ad-sp"
  name               = "Microsoft Graph"
  allowed_role_names = ["User.Read.All", "Group.Read.All", "Application.Read.All", "AppRoleAssignment.ReadWrite.All"]
}


module "zone_westeurope" {
  source                          = "../modules/zone"
  location                        = "West Europe"
  resource_group                  = module.rg.name
  app_name                        = var.app_name
  short_app_name                  = var.short_app_name
  env                             = var.env
  secrets                         = local.secrets
  configs                         = local.configs
  is_main                         = true
  appi_retention                  = 30
  appi_sku                        = "PerGB2018"
  marsoffice_sa_connection_string = module.sa_marsoffice.connection_string
  graph_api_object_id             = module.graph_api_sp.object_id
  graph_api_app_roles_ids         = module.graph_api_sp.app_roles_ids
}
