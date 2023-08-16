locals {
  location = "Sweden Central"
}

resource "azurerm_resource_group" "sa" {
  name     = "rg-storage-account"
  location = local.location
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


######################
# Service Principals #
######################

# MSP
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
resource "azuread_service_principal" "msp" {
  application_id = azuread_application.msp.application_id
}

# SP1
resource "azuread_application" "sp1" {
  display_name = "sp1"
  owners       = [azuread_service_principal.msp.object_id]
}
resource "azuread_service_principal" "sp1" {
  application_id = azuread_application.sp1.application_id
  owners         = [azuread_service_principal.msp.object_id]
}
