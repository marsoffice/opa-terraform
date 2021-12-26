terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_logic_app_workflow" "lapp" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
}
