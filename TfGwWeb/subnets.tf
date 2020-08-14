resource "azurerm_subnet" "External_subnet"  {
    name           = "External"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "10.99.0.0/24"
  }

resource "azurerm_subnet" "Internal_subnet"   {
    name           = "Internal"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "10.99.1.0/24"
  }
resource "azurerm_subnet" "DMZ1_subnet"  {
    name           = "DMZ1"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "10.99.11.0/24"
    lifecycle { 
     ignore_changes = [route_table_id]
     }
  }

resource "azurerm_subnet_route_table_association" "DMZ1_Subnet_Assoc" {
    subnet_id      = azurerm_subnet.DMZ1_subnet.id
    route_table_id = azurerm_route_table.DMZ1RT.id
  }

resource "azurerm_subnet" "DMZ2_subnet"  {
    name           = "DMZ2"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "10.99.12.0/24"
    lifecycle { 
     ignore_changes = [route_table_id]
    }
  }

resource "azurerm_subnet_route_table_association" "DMZ2_Subnet_Assoc" {
    subnet_id      = azurerm_subnet.DMZ2_subnet.id
    route_table_id = azurerm_route_table.DMZ2RT.id
  }
