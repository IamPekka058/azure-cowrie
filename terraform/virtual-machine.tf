resource "azurerm_linux_virtual_machine" "cowrie" {
  resource_group_name = azurerm_resource_group.cowrie.name
  name                = "Cowrie-Host"
  location            = var.location
  size                = "Standard_B2ats_v2"

  admin_username = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(pathexpand(var.sshpublic-key-path))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }

  network_interface_ids = [azurerm_network_interface.cowrie.id]

  custom_data = base64encode(templatefile("../assets/vm-setup.tpl", {
    workspace_id  = azurerm_log_analytics_workspace.cowrie.id
    workspace_key = azurerm_log_analytics_workspace.cowrie.primary_shared_key
  }))

  identity {
    type = "SystemAssigned"
  }
}

resource "time_sleep" "wait" {
  triggers = {
    vm_id = azurerm_linux_virtual_machine.cowrie.id
  }
  depends_on      = [azurerm_linux_virtual_machine.cowrie]
  create_duration = "120s"
}

resource "azurerm_virtual_machine_extension" "ama" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.cowrie.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.25"
  auto_upgrade_minor_version = true
  depends_on                 = [time_sleep.wait]
}