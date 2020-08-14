resource "azurerm_virtual_network" "vnet" {
  name                = "myVNET"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/20"]
  location            = "Australia East"
}
