resource "azurerm_monitor_aad_diagnostic_setting" "ad_diag_setting" {
  name = var.name
  log {
    category = "AuditLogs"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 1
    }
  }
  storage_account_id = var.storage_account_id
}
