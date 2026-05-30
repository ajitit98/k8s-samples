# Azure, you typically do not need multiple providers for different regions. You can use one Azure provider and specify different location values for resources.

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

# East US Resource Group
resource "azurerm_resource_group" "east_rg" {
  name     = "prod-east-rg"
  location = "East US"
}

# West US Resource Group
resource "azurerm_resource_group" "west_rg" {
  name     = "prod-west-rg"
  location = "West US"
}

# East US VM
resource "azurerm_linux_virtual_machine" "prod_east" {
  name                = "prod-east-vm"
  resource_group_name = azurerm_resource_group.east_rg.name
  location            = azurerm_resource_group.east_rg.location

  size           = "Standard_B1s"
  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.east_nic.id
  ]

  disable_password_authentication = false
  admin_password                  = "Password@123!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Name = "prod-east-vm"
  }
}

# West US VM
resource "azurerm_linux_virtual_machine" "prod_west" {
  name                = "prod-west-vm"
  resource_group_name = azurerm_resource_group.west_rg.name
  location            = azurerm_resource_group.west_rg.location

  size           = "Standard_B1ms"
  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.west_nic.id
  ]

  disable_password_authentication = false
  admin_password                  = "Password@123!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Name = "prod-west-vm"
  }
}