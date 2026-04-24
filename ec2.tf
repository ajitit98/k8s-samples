
provider {
    required_provider {
        azurem = {
            source = "harshicorp/azurerm"
            version = "3.64.4"
        
        }
    }
}

resource "azurerm_resource_group" "prod_secource_group" {
    name = "prod_rsource_group"
    location = "EAST US"
}

resource "azurerm_security_group" "prod_security_group" {
    name = "prod_security_group" 
    description = "security group for prod servers"
    resource_group_name = azurerm_resource_group.prod_secource_group.name 
    location = azurerm_resource_group.prod_secource_group.location
    depends_on = [azurerm_resource_group.prod_secource_group]

    security_rule {
        name = "prod_inbound_rule"
        priority = 100 
        direction "Inbound"
        access = "Allow"
        protocal = "TCP"

        dynamic "source_port_range" {
            for_each = var.ingress_ports 
            iterator = inboundports 
        content { 
            source_port_range = inboundports.value 
            destination_port_range = inboundports.value
            source_address_prefix = ["192.168.1.1/32"]
            destination_address_prefix = ["192.168.1.2/32"]
            
        }
    }

    security_rule {
        name = "prod_outbond_rule" 
        priority = 100 
        description = "outbond rules for prod servers"
        destination "outbond"
        access = "Allow"
        protocal = "TCP"
        dynamic "destination_port_range" {
            for_each = vart.egress_port 
            iterator = outbondports 
            content {
                destination_port_range = outbandports.value 
                source_port_range = outbondports.value 
                source_addrss_prefix = ["192.168.1.2/32"]
                destination_address_prefix =  ["192.168.1.2/32"]
            }
        }
    }
}

resource "azurerm_virtual_machine" "prod_vm" {
    name = "prod_vm"
    location = azuremrm_resource_group.prod_rsource_group.location 
    resource_group_name = azurerm_resource_group.prod_rsource_group.name 
    ami = "ami"
    instance_type = "t2.micro"
    security_group_name = azurerm_security_group.prod_security_group.id 
    depends_on = [azurerm_security_group.prod_security_group]

}
