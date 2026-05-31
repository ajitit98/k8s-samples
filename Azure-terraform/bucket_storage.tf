terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "prod-rg"
  location = "East US"
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "prodstorageacct12345"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "Production"
  }
}

# Blob Container (Equivalent to S3 Bucket Folder)
resource "azurerm_storage_container" "container" {
  name                  = "app-data"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}