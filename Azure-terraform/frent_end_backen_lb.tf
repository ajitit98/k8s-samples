#########################################################
# TERRAFORM SETTINGS
#########################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

#########################################################
# AZURE PROVIDER
#########################################################

provider "azurerm" {
  features {}
}

#########################################################
# VARIABLES
#########################################################

variable "location" {
  default = "East US"
}

variable "frontend_vm_count" {
  default = 2
}

variable "backend_vm_count" {
  default = 2
}

#########################################################
# RESOURCE GROUP
#########################################################

resource "azurerm_resource_group" "rg" {
  name     = "prod-rg"
  location = var.location
}

#########################################################
# VIRTUAL NETWORK
#########################################################

resource "azurerm_virtual_network" "vnet" {
  name                = "prod-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]
}

#########################################################
# FRONTEND SUBNET
#########################################################

resource "azurerm_subnet" "frontend" {
  name                 = "frontend-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = ["10.0.1.0/24"]
}

#########################################################
# BACKEND SUBNET
#########################################################

resource "azurerm_subnet" "backend" {
  name                 = "backend-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = ["10.0.2.0/24"]
}

#########################################################
# PUBLIC IP FOR INTERNET USERS
#########################################################

resource "azurerm_public_ip" "public_lb_ip" {
  name                = "public-lb-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"
}

#########################################################
# PUBLIC LOAD BALANCER
#########################################################

resource "azurerm_lb" "frontend_lb" {
  name                = "frontend-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
   sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.public_lb_ip.id
  }
}

  frontend_ip_configuration {
    name                          = "internal-ip"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address            = "10.0.2.10"
    private_ip_address_allocation = "Static"
  }
}


#########################################################
# FRONTEND BACKEND POOL
#########################################################

resource "azurerm_lb_backend_address_pool" "frontend_pool" {
  loadbalancer_id = azurerm_lb.frontend_lb.id
  name            = "frontend-pool"
}

#########################################################
# HEALTH PROBE
#########################################################

resource "azurerm_lb_probe" "frontend_probe" {
  loadbalancer_id = azurerm_lb.frontend_lb.id

  name     = "frontend-probe"
  protocol = "Tcp"
  port     = 80
}

#########################################################
# LB RULE
#########################################################

resource "azurerm_lb_rule" "frontend_rule" {
  loadbalancer_id                = azurerm_lb.frontend_lb.id
  name                           = "http-rule"
  protocol                       = "Tcp"

  frontend_port                  = 80
  backend_port                   = 80

  frontend_ip_configuration_name = "public-ip"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.frontend_pool.id
  ]

  probe_id = azurerm_lb_probe.frontend_probe.id
}

#########################################################
# INTERNAL LOAD BALANCER
#########################################################

resource "azurerm_lb" "backend_lb" {
  name                = "backend-ilb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "internal-ip"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address            = "10.0.2.10"
    private_ip_address_allocation = "Static"
  }
}

#########################################################
# BACKEND POOL
#########################################################

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.backend_lb.id
  name            = "backend-pool"
}

#########################################################
# BACKEND HEALTH PROBE
#########################################################

resource "azurerm_lb_probe" "backend_probe" {
  loadbalancer_id = azurerm_lb.backend_lb.id

  name     = "backend-probe"
  protocol = "Tcp"
  port     = 8080
}

#########################################################
# BACKEND LB RULE
#########################################################

resource "azurerm_lb_rule" "backend_rule" {
  loadbalancer_id                = azurerm_lb.backend_lb.id
  name                           = "app-rule"
  protocol                       = "Tcp"

  frontend_port                  = 8080
  backend_port                   = 8080

  frontend_ip_configuration_name = "internal-ip"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.backend_pool.id
  ]

  probe_id = azurerm_lb_probe.backend_probe.id
}

#########################################################
# FRONTEND NICs
#########################################################

resource "azurerm_network_interface" "frontend_nic" {
  count = var.frontend_vm_count

  name                = "frontend-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.frontend.id
    private_ip_address_allocation = "Dynamic"
  }
}

#########################################################
# BACKEND NICs
#########################################################

resource "azurerm_network_interface" "backend_nic" {
  count = var.backend_vm_count

  name                = "backend-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

#########################################################
# FRONTEND VMs
#########################################################

resource "azurerm_linux_virtual_machine" "frontend_vm" {
  count = var.frontend_vm_count

  name                = "frontend-vm-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  size           = "Standard_B2s"
  admin_username = "azureuser"

  admin_password                  = "Password@123456!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.frontend_nic[count.index].id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

#########################################################
# BACKEND VMs
#########################################################

resource "azurerm_linux_virtual_machine" "backend_vm" {
  count = var.backend_vm_count

  name                = "backend-vm-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  size           = "Standard_B2s"
  admin_username = "azureuser"

  admin_password                  = "Password@123456!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.backend_nic[count.index].id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

#########################################################
# ATTACH FRONTEND NICs TO FRONTEND POOL
#########################################################

resource "azurerm_network_interface_backend_address_pool_association" "frontend_assoc" {
  count = var.frontend_vm_count

  network_interface_id    = azurerm_network_interface.frontend_nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontend_pool.id
}

#########################################################
# ATTACH BACKEND NICs TO BACKEND POOL
#########################################################

resource "azurerm_network_interface_backend_address_pool_association" "backend_assoc" {
  count = var.backend_vm_count

  network_interface_id    = azurerm_network_interface.backend_nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}