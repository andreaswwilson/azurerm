locals {
  location = "Sweden Central"
}

resource "azurerm_resource_group" "sa" {
  name     = "rg-storage-account"
  location = local.location
}
