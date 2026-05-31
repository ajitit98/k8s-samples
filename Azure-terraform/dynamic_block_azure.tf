variable "ingress_rules" {
  type    = list(number)
  default = [80, 443, 8080]
}

variable "egress_rules" {
  type    = list(number)
  default = [433, 6555, 34545]
}

resource "azurerm_network_security_group" "prod_nsg" {
  name                = "prod-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.ingress_rules

    content {
      name                       = "inbound-${security_rule.value}"
      priority                   = 100 + security_rule.key
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = var.egress_rules

    content {
      name                       = "outbound-${security_rule.value}"
      priority                   = 200 + security_rule.key
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}