resource "azurerm_network_interface" "mgmtexternal" {
    name                = "r80dot40mgmt-eth0"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    enable_ip_forwarding = "false"
	ip_configuration {
        name                          = "mgmtexternalConfiguration"
        subnet_id                     = azurerm_subnet.Mgmt_subnet.id
        private_ip_address_allocation = "Static"
		private_ip_address = "10.0.0.4"
        primary = true
		public_ip_address_id = azurerm_public_ip.mgmtpublicip.id
    }

}
