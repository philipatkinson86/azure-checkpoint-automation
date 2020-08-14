# Create Azure External Load Balancer
resource "azurerm_lb" "externallb" {
  name                = "externallb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "ExternallbPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.albvip1.id
  }
}

# Create Azure Backend address pool
resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.externallb.id
  name                = "BackEndAddressPool"
}

# Create Azure Probe
resource "azurerm_lb_probe" "chkpprobe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.externallb.id
  name                = "chkp-probe"
  port                = 8117
}

# Create Azure Load Balancer Rule
resource "azurerm_lb_rule" "externallbrule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.externallb.id
  name                           = "xlbName"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8090
  frontend_ip_configuration_name = "ExternallbPublicIPAddress"
  probe_id = azurerm_lb_probe.chkpprobe.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.bpepool.id
}

# Create Azure Internal Load Balancer
resource "azurerm_lb" "internallb" {
  name                = "internallb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "InternalLBipconfig"
    subnet_id            = azurerm_subnet.Internal_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.99.1.10"
  }
}

# Create Azure Internal Load Balancer for WebServers
resource "azurerm_lb" "WebServerilb" {
  name                = "WebServerilb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "WebServerLBipconfig"
    subnet_id            = azurerm_subnet.Internal_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.99.1.11"
  }
}

# Create Azure Backend address pool
resource "azurerm_lb_backend_address_pool" "bpepoolinternal" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.internallb.id
  name                = "BackEndAddressPoolinternal"
}

# Create Azure Backend address pool for WebServers
resource "azurerm_lb_backend_address_pool" "bpepoolwebserver" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.WebServerilb.id
  name                = "BackEndAddressPoolWebservers"
}

# Create Azure Probe for WebServers
resource "azurerm_lb_probe" "WebServerprobei" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.WebServerilb.id
  name                = "http"
  port                = 80
  protocol            = "tcp"
}

# Create Azure Probe
resource "azurerm_lb_probe" "chkpprobei" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.internallb.id
  name                = "chkp-probe-internal"
  port                = 8117
}

# Create Azure Load Balancer Rule
resource "azurerm_lb_rule" "internallbrule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.internallb.id
  name                           = "ilbName"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "InternalLBipconfig"
  probe_id = azurerm_lb_probe.chkpprobei.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.bpepoolinternal.id
}

# Create Azure Load Balancer Rule for Webservers
resource "azurerm_lb_rule" "WebServerlbrule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.WebServerilb.id
  name                           = "WebServerlbName"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "WebServerLBipconfig"
  probe_id = azurerm_lb_probe.WebServerprobei.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.bpepoolwebserver.id
}
