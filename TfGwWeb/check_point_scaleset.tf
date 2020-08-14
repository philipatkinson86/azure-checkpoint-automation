resource "azurerm_virtual_machine_scale_set" "chkpscaleset" {
  name                = "chkpscaleset-1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  upgrade_policy_mode = "Manual"

  depends_on = [azurerm_marketplace_agreement.checkpoint]

  sku {
    name     = "Standard_D2_v2"
    tier     = "Standard"
    capacity = 2
  }

  plan {
       name = "sg-byol"
       publisher = "checkpoint"
       product = "check-point-cg-r8040"
       }

  storage_profile_image_reference {
    publisher = "checkpoint"
    offer     = "check-point-cg-r8040"
    sku       = "sg-byol"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix = "chkpgw"
    admin_username       = "chkpadmin"
    admin_password       = "Cpwins1!"
    custom_data =  "#!/bin/bash\nblink_config -s 'gateway_cluster_member=false&ftw_sic_key=vpn12345&upload_info=true&download_info=true'\nExtAddr=\"$(ip addr show dev eth0 | awk \"/inet/{print \\$2; exit}\" | cut -d / -f 1)\"\nIntAddr=\"$(ip addr show dev eth1 | awk \"/inet/{print \\$2; exit}\" | cut -d / -f 1)\"\ndynamic_objects -n LocalGatewayExternal -r \"$ExtAddr\" \"$ExtAddr\" -a\ndynamic_objects -n LocalGatewayInternal -r \"$IntAddr\" \"$IntAddr\" -a\nshutdown -r now\n"

  }

  os_profile_linux_config {
    disable_password_authentication = false
      }

  network_profile {
    name    = "eth0"
    primary = true
    ip_forwarding = true
    network_security_group_id = azurerm_network_security_group.scalesetnsg.id

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary = true
      subnet_id                              = azurerm_subnet.External_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      public_ip_address_configuration {
        name = "scalesetpublicconfig"
        idle_timeout = "30"
        domain_name_label = azurerm_resource_group.rg.name
      }
    }

  }
  network_profile {
    name    = "eth1"
    primary = false
    ip_forwarding = true
    network_security_group_id = azurerm_network_security_group.scalesetnsg.id

    ip_configuration {
      name                                   = "TestIPConfiguration1"
      primary = true
      subnet_id                              = azurerm_subnet.Internal_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepoolinternal.id]

    }

  }
  tags = {
          x-chkp-template = "Azure_VisualStudio_R80.40"
          x-chkp-management = "r80dot40mgmt"
          x-chkp-ip-address = "public"
          x-chkp-topology = "eth0:external,eth1:internal"
          x-chkp-anti-spoofing =  "eth0:true,eth1:false"
      }
}

resource "azurerm_monitor_autoscale_setting" "scalesetrules" {
  name                = "chkpAutoscaleSetting"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  target_resource_id  = azurerm_virtual_machine_scale_set.chkpscaleset.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 3
    }

    rule {
      metric_trigger {
        metric_name         = "Percentage CPU"
        metric_resource_id  = azurerm_virtual_machine_scale_set.chkpscaleset.id
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation    = "Average"
        operator            = "GreaterThan"
        threshold           = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name         = "Percentage CPU"
        metric_resource_id  = azurerm_virtual_machine_scale_set.chkpscaleset.id
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation    = "Average"
        operator            = "LessThan"
        threshold           = 60
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  notification {
    #operation = "Scale"
    email {
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = false
      custom_emails                         = ["youremail@here.com"]
    }
  }
}
