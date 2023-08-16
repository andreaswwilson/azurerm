resource "azurerm_resource_group" "sa" {
  name     = "rg-storage-account"
  location = "Sweden Central"
}

resource "azurerm_storage_account" "sa" {
  name                     = "andwilstorageaccount"
  resource_group_name      = azurerm_resource_group.sa.name
  location                 = azurerm_resource_group.sa.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
