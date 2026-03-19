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

resource "azapi_resource" "cowrie_table" {
  type      = "Microsoft.OperationalInsights/workspaces/tables@2022-10-01"
  name      = "Cowrie_CL"
  parent_id = azurerm_log_analytics_workspace.cowrie.id

  body = {
    properties = {
      plan = "Analytics"
      schema = {
        name = "Cowrie_CL"
        columns = [
          { name = "TimeGenerated", type = "datetime" },
          { name = "CowrieType", type = "string" },
          { name = "eventid", type = "string" },
          { name = "message", type = "string" },
          { name = "src_ip", type = "string" },
          { name = "username", type = "string" },
          { name = "password", type = "string" }
        ]
      }
      retentionInDays = 30
    }
  }
}

resource "azurerm_monitor_data_collection_rule" "cowrie" {
  resource_group_name         = azurerm_resource_group.cowrie.name
  location                    = var.location
  name                        = "${var.name}-dcr"
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.cowrie.id
  depends_on                  = [azapi_resource.cowrie_table]
  destinations {
    log_analytics {
      name                  = "${var.name}-dest"
      workspace_resource_id = azurerm_log_analytics_workspace.cowrie.id
    }
  }

  stream_declaration {
    stream_name = "Custom-Cowrie_CL"
    column {
      name = "timestamp"
      type = "string"
    }
    column {
      name = "type"
      type = "string"
    }
    column {
      name = "TimeGenerated"
      type = "datetime"
    }
    column {
      name = "CowrieType"
      type = "string"
    }
    column {
      name = "eventid"
      type = "string"
    }
    column {
      name = "message"
      type = "string"
    }
    column {
      name = "src_ip"
      type = "string"
    }
    column {
      name = "username"
      type = "string"
    }
    column {
      name = "password"
      type = "string"
    }
  }

  data_flow {
    destinations  = ["${var.name}-dest"]
    streams       = ["Custom-Cowrie_CL"]
    transform_kql = "source | extend TimeGenerated=todatetime(timestamp), CowrieType = tostring(type) | project TimeGenerated, CowrieType, eventid, src_ip, message, username, password"
    output_stream = "Custom-Cowrie_CL"
  }

  data_sources {
    log_file {
      streams       = ["Custom-Cowrie_CL"]
      file_patterns = ["/opt/cowrie/logs/*.json"]
      format        = "json"
      name          = "${var.name}-json-logfile"
    }
  }

}

resource "azurerm_monitor_data_collection_rule_association" "cowrie" {
  name                    = "${var.name}-vm-assoc"
  target_resource_id      = azurerm_linux_virtual_machine.cowrie.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.cowrie.id
}