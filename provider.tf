terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
  subscription_id     = "cec8d728-7497-4f8c-b344-87b95fcc6e92"
  tenant_id           = "ad7e197d-b1f9-411a-8c1d-f7c87c21f636"
  storage_use_azuread = "true"
  use_oidc            = true
}

terraform {
  backend "azurerm" {
    key              = "terraform.tfstate"
    use_azuread_auth = true
    use_oicd         = true
  }
}
