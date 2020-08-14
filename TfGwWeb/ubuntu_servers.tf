resource "azurerm_network_interface" "ubuntuDMZ1" {
    name                = "ubuntuDMZ1"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntuDMZ1Configuration"
        subnet_id                     = azurerm_subnet.DMZ1_subnet.id
        private_ip_address_allocation = "Static"
        private_ip_address = "10.99.11.10"
    }
}

resource "azurerm_network_interface_backend_address_pool_association" "backendwebserver_assoc1" {
  network_interface_id    = azurerm_network_interface.ubuntuDMZ1.id
  ip_configuration_name   = "ubuntuDMZ1Configuration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bpepoolwebserver.id
}

resource "azurerm_network_interface" "ubuntuDMZ2" {
    name                = "ubuntuDMZ2"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntuDMZ2Configuration"
        subnet_id                     = azurerm_subnet.DMZ2_subnet.id
        private_ip_address_allocation = "Static"
        private_ip_address = "10.99.12.10"
    }
}

resource "azurerm_network_interface_backend_address_pool_association" "backendwebserver_assoc2" {
  network_interface_id    = azurerm_network_interface.ubuntuDMZ2.id
  ip_configuration_name   = "ubuntuDMZ2Configuration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bpepoolwebserver.id
}

resource "azurerm_virtual_machine" "ubuntudmz1" {
    name                  = "ubuntudmz1"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.ubuntuDMZ1.id]
    vm_size               = "Standard_B1s"
    availability_set_id   = azurerm_availability_set.avset.id

    storage_os_disk {
        name              = "ubuntudmz1disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz1"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
        custom_data =  "#!/bin/bash\nuntil sudo apt-get update && sudo apt-get -y install apache2;do\nsleep 1\n done\n until curl --output /var/www/html/vsec.jpg --url https://www.checkpoint.com/wp-content/uploads/cloudguard-iaas-236x150.png ; do \n sleep1 \n done\nsudo echo $HOSTNAME > /var/www/html/index.html\nsudo echo \"<BR><BR>Hello World - Check Point CloudGuard IAAS Demo !<BR><BR>\" >> /var/www/html/index.html\n sudo echo \"<img src=\"/vsec.jpg\" height=\"25%\">\" >> /var/www/html/index.html"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

}

resource "azurerm_virtual_machine" "ubuntudmz2" {
    name                  = "ubuntudmz2"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.ubuntuDMZ2.id]
    vm_size               = "Standard_B1s"
    availability_set_id   = azurerm_availability_set.avset.id

    storage_os_disk {
        name              = "ubuntudmz2disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz2"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
 custom_data =  "#!/bin/bash\nuntil sudo apt-get update && sudo apt-get -y install apache2;do\nsleep 1\n done\n until curl --output /var/www/html/vsec.jpg --url https://www.checkpoint.com/wp-content/uploads/cloudguard-iaas-236x150.png ; do \n sleep1 \n done\nsudo echo $HOSTNAME > /var/www/html/index.html\nsudo echo \"<BR><BR>Hello World - Check Point CloudGuard IAAS Demo !<BR><BR>\" >> /var/www/html/index.html\n sudo echo \"<img src=\"/vsec.jpg\" height=\"25%\">\" >> /var/www/html/index.html"

    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

}
