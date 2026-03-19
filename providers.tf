terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.64.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "2.8.0"
    }
  }
}

provider "azurerm" {
  features {}
}