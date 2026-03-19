
resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "Virtual-Network"
  location            = var.location
  address_space       = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "cowrie" {
  resource_group_name  = azurerm_resource_group.cowrie.name
  name                 = "${var.name}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
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