resource "azurerm_resource_group" "RG" {
    name     = var.resource_group_name
    location = var.location
    tags = {
        environment = "Test"
    }
}
resource "azurerm_virtual_network" "vnet" {
    name      = "${var.prefix}-network"
    location  = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    address_space = ["10.100.0.0/16"]
    /*subnet {
    name = "Frontend"
    address_prefix = "10.100.1.0/24"
    }
    subnet {
    name = "Backend"
    address_prefix = "10.100.2.0/24"
    }*/
}
resource "azurerm_subnet" "subnet" {
  name                 = "Frontend"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.1.0/24"]  # Replace with your desired address range
}

/*resource "azurerm_user_assigned_identity" "RBAC" {
  name    = "${var.name[1]}"
  location = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}
resource "azurerm_user" "user" {
  for_each = [var.account_name]
  name     ="${each.value}-role"
}*/
data "azurerm_resource_group" "RG" {
  name = azurerm_resource_group.RG.name
}

data "azurerm_subnet" "subnet" {
   name = "Frontend"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.RG.name
}

resource "azurerm_public_ip" "pip" {
name  ="mypublicIP-test"
location ="${data.azurerm_resource_group.RG.location}"
resource_group_name = "${data.azurerm_resource_group.RG.name}"
allocation_method = "Dynamic"  
  
}
resource "azurerm_network_interface" "nic" {
name  ="nic-test"
location ="${data.azurerm_resource_group.RG.location}"
resource_group_name = "${data.azurerm_resource_group.RG.name}"
ip_configuration {
  name = "testconfiguration1"
  subnet_id = "${data.azurerm_subnet.subnet.id}"
  private_ip_address_allocation = "Dynamic"
}
}
resource "azurerm_virtual_machine" "vm" {
name = "myVM-test"
resource_group_name = "${data.azurerm_resource_group.RG.name}"
location = "${azurerm_network_interface.nic.location}"
network_interface_ids = ["${azurerm_network_interface.nic.id}"]
vm_size = "standard_DS1_v2"
delete_os_disk_on_termination = true
delete_data_disks_on_termination =true

storage_image_reference {
  publisher = "canonical"
  offer = "ubuntuserver"
  sku = "16.04-LTS"
  version = "latest"
}
storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}
