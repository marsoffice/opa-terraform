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

module "eh_ad_audit" {
  source         = "../modules/eh"
  location       = var.location
  name           = "eh-${var.app_name}-ad-audit-${var.env}"
  resource_group = var.resource_group
  capacity       = null
  sku            = "Basic"
  zone_redundant = true
}

module "ad_diag_setting" {
  source                         = "../modules/ad-diag-setting"
  name                           = "eh-audit-${var.env}"
  eventhub_authorization_rule_id = module.eh_ad_audit.authorization_rule_id
  event_hub_name                 = module.eh_ad_audit.name
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
  allowed_principals = tomap({ ad_sync_principal = module.ad_sync_lapp.principal_id })
}

module "ad_sync_lapp" {
  source         = "../modules/lapp"
  location       = var.location
  resource_group = var.resource_group
  name           = "lapp-${var.app_name}-ad-sync-${var.env}"
}

