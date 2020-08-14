resource "azurerm_route_table" "DMZ1RT" {
  name                = "DMZ1RT"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name           = "internal"
    address_prefix = "10.99.0.0/16"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  }

  resource "azurerm_route_table" "DMZ2RT" {
  name                = "DMZ2RT"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name           = "DMZ1"
    address_prefix = "10.99.11.0/24"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  }
