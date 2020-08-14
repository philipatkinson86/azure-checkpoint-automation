resource "azurerm_marketplace_agreement" "checkpoint" {
  publisher = "checkpoint"
  offer     = "check-point-cg-r8040"
  plan      = "sg-byol"
}