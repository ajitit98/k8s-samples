
terraform {
    required_providers {
        azurerm = {
            source "hashicorpazurerm" 
            version = "=4.1" 
        }
    }
}
provider "azurerm" {
    features {
    }
}

resource "azurerm_resource_group" "East_us" {
    name = "prod_east"
    location = "East us" 
}

resource "azurerm_resource_group" "West_us" {
    name = "prod_west" 
    location = "West US"
}

resource "azurerm_linux_virtual_machine" "East_vm" {
    name = "Prod_east_vm"
    resource_group_name = azurerm_resource_group.East_us.name 
    location = azurerm_resource_group.East_us.location 

    size = "standard_B1s" 
    admin_username = admiuser
    admin_password = admin_pass
    network_interface_ids = [
        azurerm_network_interface.East_nic.id 
    ]

   disable_password_authentication = false 
   os_disk {
    caching = "ReadWrite"
   }

   source_image_reference {
    publisher = "Cononical"
    sku = "22_04-lts" 
    offer = "Ubuntu"
    version = "latest" 
   }



}