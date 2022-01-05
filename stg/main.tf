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
