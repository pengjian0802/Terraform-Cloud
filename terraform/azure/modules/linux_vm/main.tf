resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.resource_group_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_group_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vm_name}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "${var.vm_name}-nsg"
  location            = var.resource_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowOpenShift"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "6443", "22623", "8080"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "network_interface" {
  name                = "${var.vm_name}-nic"
  location            = var.resource_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.resource_location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "rh-ocp-worker-gen1"
    product   = "rh-ocp-worker"
    publisher = "redhat"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}

output "vm-name" {
  value       = azurerm_linux_virtual_machine.linux_virtual_machine.name
  description = "The name of the virtual machine."
}

output "vm-public-ip" {
  value       = azurerm_public_ip.public_ip.ip_address
  description = "The public IP address of the virtual machine."
}