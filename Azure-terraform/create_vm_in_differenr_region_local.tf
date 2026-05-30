locals {
  regions = {
    us = {
      location = "East US"
    }

    india = {
      location = "Central India"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "us_rg" {
  name     = "prod-us-rg"
  location = local.regions.us.location
}

resource "azurerm_resource_group" "india_rg" {
  name     = "prod-india-rg"
  location = local.regions.india.location
}