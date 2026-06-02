############################################################
# Terraform Configuration
############################################################

terraform {
  required_version = ">= 1.5.0"

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
#
# All Azure resources are deployed inside a Resource Group.
############################################################

resource "azurerm_resource_group" "dns_rg" {
  name     = "prod-dns-rg"
  location = "Central India"
}

############################################################
# Azure DNS Zone
#
# Creates a public DNS zone.
#
# Example:
# example.com
#
# Azure will automatically generate NS records
# which must be configured at your domain registrar.
############################################################

resource "azurerm_dns_zone" "main" {
  name                = "example.com"
  resource_group_name = azurerm_resource_group.dns_rg.name

  tags = {
    Environment = "Production"
    Owner       = "DevOps"
  }
}

############################################################
# A Record
#
# Maps a hostname to an IPv4 address.
#
# Result:
# www.example.com --> 20.55.100.10
############################################################

resource "azurerm_dns_a_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.dns_rg.name

  ttl = 300

  records = [
    "20.55.100.10"
  ]
}

############################################################
# CNAME Record
#
# Creates an alias.
#
# Result:
# app.example.com --> www.example.com
############################################################

resource "azurerm_dns_cname_record" "app" {
  name                = "app"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.dns_rg.name

  ttl = 300

  record = "www.example.com"
}

############################################################
# MX Record
#
# Used for email routing.
#
# Mail sent to:
# user@example.com
#
# will be routed to:
# mail.example.com
############################################################

resource "azurerm_dns_mx_record" "mail" {
  name                = "@"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.dns_rg.name

  ttl = 300

  record {
    preference = 10
    exchange   = "mail.example.com"
  }
}

############################################################
# TXT Record
#
# Commonly used for:
# - Domain Verification
# - SPF
# - DKIM
# - Security Validation
#
# Result:
# verify.example.com
############################################################

resource "azurerm_dns_txt_record" "verification" {
  name                = "verify"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.dns_rg.name

  ttl = 300

  record {
    value = "terraform-managed-domain"
  }
}

############################################################
# Output DNS Name Servers
#
# After deployment Azure provides NS records.
#
# These NS records must be configured
# at your domain registrar (GoDaddy, Namecheap, etc.)
############################################################

output "dns_name_servers" {
  description = "Azure DNS Name Servers"

  value = azurerm_dns_zone.main.name_servers
}

############################################################
# Output DNS Zone Name
############################################################

output "dns_zone_name" {
  value = azurerm_dns_zone.main.name
}