
resource "azurerm_virtual_network" "cowrie" {
  resource_group_name = azurerm_resource_group.cowrie.name
  name                = "${var.name}-vnet"
  location            = var.location
  address_space       = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "cowrie" {
  resource_group_name  = azurerm_resource_group.cowrie.name
  name                 = "${var.name}-subnet"
  virtual_network_name = azurerm_virtual_network.cowrie.name
  address_prefixes     = ["10.0.1.0/25"]
}

resource "azurerm_public_ip" "cowrie" {
  resource_group_name = azurerm_resource_group.cowrie.name
  name                = "${var.name}-public-ip"
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "cowrie" {
  resource_group_name = azurerm_resource_group.cowrie.name
  name                = "${var.name}-network-interface"
  location            = var.location

  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = azurerm_subnet.cowrie.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cowrie.id
  }
}

resource "azurerm_network_security_group" "cowrie" {
  resource_group_name = azurerm_resource_group.cowrie.name
  name                = "${var.name}-nsg"
  location            = var.location
}

resource "azurerm_network_security_rule" "allowAdminSSH" {
  resource_group_name         = azurerm_resource_group.cowrie.name
  network_security_group_name = azurerm_network_security_group.cowrie.name
  name                        = "AllowAdminSSH"
  direction                   = "Inbound"
  source_port_range           = "*"
  destination_port_range      = 22222
  destination_address_prefix  = "*"
  source_address_prefix       = "*"
  protocol                    = "Tcp"
  priority                    = 100
  access                      = "Allow"
}

resource "azurerm_network_security_rule" "allowHoneypotSSH" {
  resource_group_name         = azurerm_resource_group.cowrie.name
  network_security_group_name = azurerm_network_security_group.cowrie.name
  name                        = "AllowHoneypotSSH"
  direction                   = "Inbound"
  source_port_range           = "*"
  destination_port_range      = 22
  destination_address_prefix  = "*"
  source_address_prefix       = "*"
  protocol                    = "Tcp"
  priority                    = 110
  access                      = "Allow"
}

resource "azurerm_network_interface_security_group_association" "cowrie" {
  network_interface_id      = azurerm_network_interface.cowrie.id
  network_security_group_id = azurerm_network_security_group.cowrie.id
}