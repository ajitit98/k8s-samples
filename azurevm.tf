
provider {
    required-provider {
        azurrm = {
            source = "harshicorp/azurerm"
            version = "3.63.4"
        }
    }
}

resource "azurerm_resource_group" "prod_security_group" {
    name = "prod-resource_group"
    description = "resource group for production server" 
    location = "EAST US"
}

resource "azurerm_network_security_group" "prod_network_security_group" {
    name = "prod_network_seurity_group"
    description = "network security for prod server"
    resource_group_name = azurerm_resource_group.prod_security_group.name 
    location = azurerm_resource_group.prod_security_group.location 
}


resource "azurerm_virtual_networK" "prod_virtual_network" {
    name = "prod_virtual_network" 
    description = "virtual network for prod server" 
    resource_group_name = azurerm_resource_group.prod_security_group.name 
    location = azurerm_resource_group.prod_security_group.location 
    address_prefix = ["192.168.0.0/16"]
    dns_prefix = ["192.168.1.100","192.168.1.101"]
    subnets = {
        name = "prod_subnet_1"
        addrsss_prefix = ["192.168.1.0/24"]
        description = "subnet for prod server with internetaccess"

    }
    subnets = {
        name "prod_subnet-2"
        desciption = "sunnet for prod server without intenet "
        addrress_prefix = ["192.168.2.0/32"]
    }

  ressource "azurerm_linux_virtual_machine" "prod_linux_vm" {
    name = "prod_linux_vm"
    resource_group_name = azurerm_resource_group.prod_security_group.name 
    location = azurerm_resource_group.prod_security_group.location 
    ami = "ubunti-20.04"
    instance_type = "standard_ds1_v2"
    azurerm_network_security_group_id = azurerm_network_security_group.prod_network_security_group.id 
    azurerm_virtual 
  }

}