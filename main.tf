terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "azurerm" {
  features {}

  subscription_id = subscription_id
  client_id       = client_id
  client_secret   = client_secret
  tenant_id       = tenant_id
}

resource "azurerm_virtual_machine" "example_server" {
  name                  = var.instanceName
  location              = var.azureRegion
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = var.instanceType

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "example_os_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.instanceName
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Name = var.instanceName
  }
}

resource "azurerm_resource_group" "example" {
  name     = "${var.instanceName}-rg"
  location = var.azureRegion
}

resource "azurerm_network_interface" "example" {
  name                = "${var.instanceName}-nic"
  location            = var.azureRegion
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.instanceName}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.azureRegion
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${var.instanceName}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}