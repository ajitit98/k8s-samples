terraform {
    required_providers {
        azurerm = {
            source = "harshicorp/azurerm"
            version = "=4.1.0"
        }
    }
}

provider "azurerm" {
    features {

    }
}

variable "vm_size" {
    description = "vm size" 
    type = string
    default = "standard_B1s"
}

locals {
environment = var.vm_size == "standard_B1s" ? "dev" : 
              var.vm_size == "standard_ D2s-v2" "prod" : "other" 
} 

resource "azurerm_resource_group_name" "rg" {
    name = "prod_rg" 
    location = "East US" 
}

resource "azurerm_virtual_network" "vnet" {
    name = "prod_vnet" 
    resource_group_name = azurerm_resource_group.rg.name 
    location = azurerm_resource_group.rg.location 
    address_space = ["1.0.0.0.0/16"] 
}

resource "azurerm_subnet" "sub1" {
    name = "prod_sub1" 
    resource_group_name = azurerm_resource_group.rg.name 
    locatin = azurerm_resource_group.rg.location
    address_prefixes = ["10.0.1.0/24"] 
}

resource "azurerm_public_ip" "pub" {
    name = "prod_pub" 
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "static" 
}

resource "azurerm_network_interface" "nic1" {
    name = "prod_nic1" 
    resource_group_nmae = azurerm_resource_group.rg.name 
    location = azurerm_resource_group.rg.location
    ip_configuration {
        name = "internal" 
        subnet_id = azurerm_subnet.sub1.id 
        private_ip_address_allocation = "Dynamic" 
        public_ip_adddress_id = "static"
    }
}

resource "azurerm_liux_virtual_machine" "vm" {
    name = "prod_vm" 
    resource_group_name = azurerm_resource_group.rg.name 
    location = azurerm_resource_group.rg.location 
    vm_size = "standard_B1s" 
    admin_username = admiuser 
    admi_password = admi_password 
    network_interface_ids = [
        azurerm_networkd_interface.nic.id
    ]

   disk_size {
    caching = "ReadWrite"
    storage_account_type = "Standard-LRS"
   }
   source_image_references {
    publisher = "Cononical" 
    offer = "ubuntu"
    sku = "22_04-lts" 
    version = "latest"
   }

}