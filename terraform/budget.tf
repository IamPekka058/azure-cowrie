resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "${var.name}-budget"
  resource_group_id = azurerm_resource_group.cowrie.id

  amount     = var.budget-amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
  }

  dynamic "notification" {
    for_each = var.budget-thresholds
    content {
      enabled        = true
      threshold      = notification.value
      operator       = "GreaterThan"
      contact_emails = [var.budget-alert-mail]
    }
  }

  lifecycle {
    ignore_changes = [
      time_period
    ]
  }
}