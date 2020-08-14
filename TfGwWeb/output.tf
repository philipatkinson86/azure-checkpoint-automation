output "External_Load_Balancer_Public_IP_Address" {
  value =  azurerm_public_ip.albvip1.ip_address
}
