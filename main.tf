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

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # MS Graph app id.

    resource_access {
      id   = "18a4783c-866b-4cc7-a460-3d5e5662c884" # Application.ReadWrite.OwnedBy
      type = "Scope"
    }
  }

}

# Create Service Principal
resource "azuread_service_principal" "msp" {
  application_id = azuread_application.msp.application_id
  depends_on     = [azuread_application.msp]
}

# Create Azure AD App -
resource "azuread_application" "sp1" {
  display_name = "sp-sp1"
  owners       = [azuread_service_principal.msp.object_id]
}

# Create Service Principal
resource "azuread_service_principal" "sp1" {
  application_id = azuread_application.msp.application_id
  owners         = [azuread_service_principal.msp.object_id]
}
