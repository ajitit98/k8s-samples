
terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 4.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "prod_rg" {
    name = "prod_rg" 
    location = "Central India"
}

resource "azurerm_storage_account" "prod_storage" {
    name = "prrodstorafccount"
    resource_group_name = azurerm_resource_group.prod_rg.name 
    location = azurerm_resource_group.prod_rg.location
    account_tier = "standard"
    account_replication_type = "LRS" 
}

resource "azurerm_storage_containers" "prod_container" {
    name = "prod_container" 
    storage_account_id = azurerm_storage_account.prod_storage.id
    container_access_type = "private"
}