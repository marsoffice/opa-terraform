
output "id" {
  value = data.azurerm_storage_account.sa.id
}

output "connection_string" {
  value = data.azurerm_storage_account.sa.primary_connection_string
}
