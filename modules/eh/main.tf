terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_eventhub_namespace" "eh_ns" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.sku
  capacity            = var.capacity
  zone_redundant      = var.zone_redundant
}

resource "azurerm_eventhub" "eh" {
  name                = var.name
  namespace_name      = azurerm_eventhub_namespace.eh_ns.name
  resource_group_name = var.resource_group
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_namespace_authorization_rule" "eh_ar" {
  name                = var.name
  namespace_name      = azurerm_eventhub_namespace.eh_ns.name
  resource_group_name = var.resource_group

  listen = true
  send   = true
  manage = true
}
