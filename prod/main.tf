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
  }
}

provider "azurerm" {
  features {}
}


module "sa" {
  source         = "../modules/sa"
  name           = "samarsoffice"
  resource_group = "rg-marsoffice"
}

module "ad_diag_setting" {
  source             = "../modules/ad-diag-setting"
  name               = "sa-audit-${var.env}"
  storage_account_id = module.sa.id
}
