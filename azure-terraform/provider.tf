provider "azurerm" {
  features {}

  subscription_id = "76fe814b-055a-4f79-8f7f-c92b44024c6c"
  tenant_id       = "9279b88e-6c85-4493-9847-eef5b147ce12"
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"  # or any version you prefer
    }
  }
}