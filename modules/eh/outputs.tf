output "name" {
  value = azurerm_eventhub.eh.name
}

output "authorization_rule_id" {
  value = azurerm_eventhub_namespace_authorization_rule.eh_ar.id
}
