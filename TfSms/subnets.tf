resource "azurerm_subnet" "Mgmt_subnet"  {
    name           = "Mgmt"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "10.0.0.0/24"
  }