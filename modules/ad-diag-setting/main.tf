resource "azurerm_monitor_aad_diagnostic_setting" "ad_diag_setting" {
  name = var.name
  log {
    category = "AuditLogs"
    enabled  = true
    retention_policy {
      enabled = true
    }
  }
  // eventhub_name                  = var.event_hub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
}
