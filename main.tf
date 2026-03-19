resource "azurerm_resource_group" "cowrie" {
  name     = "${var.name}"
  location = var.location
}