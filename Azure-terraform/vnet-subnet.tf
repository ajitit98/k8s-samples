terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm" 
            version = "=4.1.0"
        }
    }
}

provider "azurerm" {
    features {} 
}


resource "azurerm_resource_group" "rg" {
    name = "prod_rg" 
    location = "East US" 
}

resource "azurerm_virtual_network" "vnet" {
    name = "prod_vnet" 
    resource_group_name = azurerm_resource_group.rg.name 
    location = azurerm_resource_group.rg.location 
    address_space = ["10.0.0.0/16"] 
}

resource "azurerm_subnet" "sub_1" {
    name = "prod_subnet_1" 
    resource_group_name = azurerm_resource_group.rg.name 
    virtual_network_name = azurerm_virtual_network.vnet.name 
    address_prefixes = ["10.0.1.0/24"] 
}