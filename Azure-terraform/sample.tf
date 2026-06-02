
resource "azurerm_network_interface" "prod_public-nic" {
    name = "prod_public_nic" 
    location = azurerm_resource_group.rg.name
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name = "internal" 
        subnet_id = azurerm_subnet.frontend_subnet.id
        private_ip_address_allocation_method = "Dynamic" 
    }
}

resource "azurerm_virtual_network" "backend_nic" {
    name = "backend_nic" 
    location = azurerm_resource_group.rg.name 
    resource_group_name = azurerm_resource_group.rg.name 
    if_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.backend_subnet.id 
        private_ip_address_allocation_method = "Dynamic" 
    }
}

resource "azurerm_linux_virtual_machine" "prod_frontend" {
    name = "prod_front_end" 
    location = azurerm_resource_group.rg.location 
    resource_group_name = azurerm_resource_group.rg.name 0
    size = "standard_B2s" 
    admin_username = "azureuser"
    admin_password = "azurerm_password" 
    disable_password_authentication = false 
    network_interface_ids = [
        azurerm_network_interface.prod_public-nic.id
    ]
    os_disk {
        caching = "ReadWrite" 
        storage_account_type = "standard-LRS"
    }

    source_image_reference {
        publisher = "Cononical"
        offer = "ubuntu" 
        sku = "22_04-lts"
        version = "latest"
    }
}

resource "azurerm_linux_virtual_machine" "prod_backend" {
    name = "prod_backend_vm"
    location = azurerm_resource_group.rg.location 
    resource_group_nmae = azurerm_resource_group.rg.name
    size = "standard_B2s"
    admin_username = "adminuser" 
    admi_password =  "admin_password" 
    disable_password_authentication = false
    network_interfacer_ids = [
        azurerm_network_interface.backend_nic.id
    ]
    os_disk {
        caching "ReadWrite" 
        storage_account_type = "LRS"
    }
    source_image_refrence {
        publisher = "Cononical"
        offer = "ubuntu"
        sku = "22_04-lts" 
        version = "latest" 
    }
}


resource  "azurerm_network_interface_backend_address_pool_assocation" "frontend_asso" {
    name = "fronetend_pool_asso" 
    network_interface_id = azurerm_network_interface.frontend_nic.id
    ip_configure_name = "internal" 
    backend_address_pool_id = azurerm_lb_backend_addres_pool.id 
}


resource "azurerm_network_interface_backend_address_pool_association" "frontens_assoc" {
    name = "frontend_ass" 
    network_interface_id = azurerm_network_interface.frontend_nic.id
    ip_configure_name = "internal"
    backend_address_pool_id = azurerm_lb.backend_address_pool.frontend_pool.id 
}