resource "azurerm_log_analytics_workspace" "cowrie" {
  resource_group_name = azurerm_resource_group.cowrie.name
  name                = "${var.name}-logs"
  location            = var.location
}

resource "azurerm_monitor_data_collection_endpoint" "cowrie" {
  resource_group_name = azurerm_resource_group.cowrie.name
  location            = var.location
  name                = "${var.name}-dce"
  kind                = "Linux"
}