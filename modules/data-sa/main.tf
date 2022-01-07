
data "azurerm_storage_account" "sa" {
  name                = var.name
  resource_group_name = var.resource_group
}
