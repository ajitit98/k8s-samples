############################################################
# Terraform Configuration
############################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

############################################################
# Azure Provider
############################################################

provider "azurerm" {
  features {}
}

############################################################
# Resource Group
############################################################
# A logical container that holds all Azure resources.
############################################################

resource "azurerm_resource_group" "rg" {
  name     = "prod-rg"
  location = "East US"
}

############################################################
# Virtual Network
############################################################
# Creates a private network in Azure.
############################################################

resource "azurerm_virtual_network" "vnet" {
  name                = "prod-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]
}

############################################################
# Subnet
############################################################
# Subnet where application VMs will be deployed.
############################################################

resource "azurerm_subnet" "web_subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = ["10.0.1.0/24"]
}

############################################################
# Public IP
############################################################
# Public entry point for Internet traffic.
############################################################

resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"
}

############################################################
# Azure Load Balancer
############################################################
# Receives traffic from users.
############################################################

resource "azurerm_lb" "web_lb" {
  name                = "web-loadbalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

############################################################
# Backend Address Pool
############################################################
# Group of backend servers that receive traffic.
#
# Similar to AWS Target Group.
############################################################

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name            = "web-backend-pool"
}

############################################################
# Health Probe
############################################################
# Checks if backend servers are healthy.
#
# Every 5 seconds Azure checks port 80.
# If VM stops responding, it is removed
# from traffic distribution.
############################################################

resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id = azurerm_lb.web_lb.id

  name     = "http-probe"
  protocol = "Tcp"
  port     = 80
}

############################################################
# Load Balancing Rule
############################################################
# Frontend Port 80
# Backend Port 80
#
# Client ---> LB ---> Backend Pool
############################################################

resource "azurerm_lb_rule" "http_rule" {
  loadbalancer_id                = azurerm_lb.web_lb.id
  name                           = "http-rule"
  protocol                       = "Tcp"

  frontend_port                  = 80
  backend_port                   = 80

  frontend_ip_configuration_name = "public-frontend"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.backend_pool.id
  ]

  probe_id = azurerm_lb_probe.http_probe.id
}

############################################################
# Network Interface
############################################################
# Example NIC attached to a VM.
############################################################

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm1-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

############################################################
# Associate NIC with Backend Pool
############################################################
# This tells Azure:
#
# VM NIC
#   ↓
# Backend Pool
#   ↓
# Load Balancer
############################################################

resource "azurerm_network_interface_backend_address_pool_association" "vm1_backend" {
  network_interface_id    = azurerm_network_interface.vm_nic.id

  ip_configuration_name   = "internal"

  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}