resource "azurerm_application_insights_workbook" "cowrie_dashboard" {
  name                = uuid()
  resource_group_name = azurerm_resource_group.cowrie.name
  location            = var.location
  display_name        = "Cowrie Honeypot Analysis"

  source_id = lower(azurerm_log_analytics_workspace.cowrie.id)
  category  = "workbook"

  data_json = file("../assets/Analysis.workbook")

  tags = {
    Project = "Honeypot"
  }
}