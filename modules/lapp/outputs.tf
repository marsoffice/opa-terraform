output "id" {
  value = azurerm_logic_app_workflow.lapp.id
}

output "principal_id" {
  value = azurerm_logic_app_workflow.lapp.identity.principal_id
}
