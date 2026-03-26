terraform {
  required_version = "1.14.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.66.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "2.9.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "azurerm" {
  features {}
}