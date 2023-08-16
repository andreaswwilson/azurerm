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
}
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

########## Service principal ########## 
data "azuread_client_config" "current" {}

# Create Azure AD App -
resource "azuread_application" "msp" {
  display_name = "sp-msp"
  owners       = [data.azuread_client_config.current.object_id]
}

# Create Service Principal
resource "azuread_service_principal" "msp" {
  application_id = azuread_application.msp.application_id
  depends_on     = [azuread_application.msp]
  owners         = [data.azuread_client_config.current.object_id]
}


# Create Azure AD App -
resource "azuread_application" "sp1" {
  display_name = "sp-sp1"
  owners       = [azuread_service_principal.msp.object_id]
}

# Create Service Principal
resource "azuread_service_principal" "sp1" {
  application_id = azuread_application.msp.application_id
  depends_on     = [azuread_application.sp1]
  owners         = [azuread_service_principal.msp.object_id]
}
