terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">2.39.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-storage-account"
    storage_account_name = "andwilstorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
