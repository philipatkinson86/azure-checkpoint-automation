resource "azurerm_virtual_network" "vnet" {
  name                = "Labvnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.99.0.0/16"]
  location            = azurerm_resource_group.rg.location
}