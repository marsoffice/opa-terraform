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
      version = "2.90"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  secrets = tomap({

  })
}

module "appi" {
  source         = "../modules/appi"
  location       = var.location
  name           = "appi-${var.app_name}-${var.env}"
  resource_group = var.resource_group
  retention      = 30
  sku            = "PerGB2018"
}

module "kvl" {
  source         = "../modules/kvl"
  location       = var.location
  resource_group = var.resource_group
  name           = "kvl-${var.app_name}-${var.env}"
  secrets = merge(local.secrets, tomap({

  }))
  allowed_principals = [module.ad_sync_lapp.principal_id]
}

module "ad_sync_lapp" {
  source         = "../modules/lapp"
  location       = var.location
  resource_group = var.resource_group
  name           = "lapp-ad-sync-${var.app_name}-${var.env}"
}

