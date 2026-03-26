terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

data "azuread_client_config" "current" {}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azuread_service_principal" "gta_sp" {
  client_id = var.sp_client_id
}

resource "azuread_service_principal_password" "sp_password" {
  service_principal_id = data.azuread_service_principal.gta_sp.id
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.resource_group_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_group_name}-subnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vm_name}-public-ip"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = var.tags
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "${var.vm_name}-nsg"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

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
  tags = var.tags
}

resource "azurerm_network_interface" "network_interface" {
  name                = "${var.vm_name}-nic"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current_subscription" {}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
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

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
  disable_password_authentication = true

  # Pre-requisites
  provisioner "remote-exec" {
    inline = [
      # Step1: Install Dependencies
      "sudo dnf install -y wget tar gzip podman curl",
      # Step2: Download ocp-install and oc client
      "wget -c https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz -O /tmp/ocp-install.tar.gz",
      "wget -c https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz -O /tmp/oc-client.tar.gz",
      "sudo tar -xf /tmp/ocp-install.tar.gz -C /usr/local/bin",
      "sudo tar -xf /tmp/oc-client.tar.gz -C /usr/local/bin",
      "sudo chmod +x /usr/local/bin/openshift-install /usr/local/bin/oc",
      # Step3: Create install config directory
      "mkdir -p /home/${var.admin_username}/ocp-install",
      "mkdir -p /home/${var.admin_username}/.azure",
      # Step4: Clean up tmp
      "rm -f /tmp/ocp-install.tar.gz /tmp/oc-client.tar.gz"
    ]
    connection {
      type        = "ssh"
      user        = var.admin_username
      host        = azurerm_public_ip.public_ip.ip_address
      port        = 22
      private_key = var.admin_ssh_private_key
      timeout     = "30m"
    }
  }

  provisioner "file" {
    content = templatefile("${path.module}/osServicePrincipal.json.tpl", {
      subscription_id  = data.azurerm_subscription.current_subscription.subscription_id
      sp_client_id     = var.sp_client_id
      sp_client_secret = azuread_service_principal_password.sp_password.value
      tenant_id        = data.azuread_client_config.current.tenant_id
    })
    destination = "/home/${var.admin_username}/.azure/osServicePrincipal.json"
    connection {
      type        = "ssh"
      user        = var.admin_username
      host        = azurerm_public_ip.public_ip.ip_address
      port        = 22
      private_key = var.admin_ssh_private_key
      timeout     = "30m"
    }
  }

  # Step5: Push install-config.yaml
  provisioner "file" {
    content = templatefile("${path.module}/install-config.yaml.tpl", {
      ocp_base_domain     = var.ocp_base_domain
      ocp_cluster_name    = var.ocp_cluster_name
      ocp_location        = var.ocp_location
      ocp_base_domain_rg  = var.ocp_base_domain_rg
      ocp_master_replicas = var.ocp_master_replicas
      # ocp_master_size = var.ocp_master_size
      ocp_worker_replicas = var.ocp_worker_replicas
      # ocp_worker_size = var.ocp_worker_size
      ocp_pull_secret    = file("${path.module}/ocp_pull_secret.json")
      ocp_ssh_public_key = var.ocp_ssh_public_key
    })
    destination = "/home/${var.admin_username}/ocp-install/install-config.yaml"
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.public_ip.ip_address
      port        = 22
      user        = var.admin_username
      private_key = var.admin_ssh_private_key
    }
  }

  provisioner "remote-exec" {
    inline = [
      # Step6: Change ownership of install-config.yaml
      "sudo chown ${var.admin_username}:${var.admin_username} /home/${var.admin_username}/ocp-install/install-config.yaml",
      # Step7: Exec ocp cluster deploy
      "cd /home/${var.admin_username}/ocp-install && openshift-install create cluster --dir . --log-level=debug 2>&1 | tee /home/${var.admin_username}/ocp-install/ocp-install.log",
      # Copy 
      "cp /home/${var.admin_username}/ocp-install/auth/kubeconfig /home/${var.admin_username}/ocp-kubeconfig",
      "cp /home/${var.admin_username}/ocp-install/auth/kubeadmin-password /home/${var.admin_username}/ocp-password"
    ]
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.public_ip.ip_address
      port        = 22
      user        = var.admin_username
      private_key = var.admin_ssh_private_key
      timeout     = "60m"
    }
  }
  tags = var.tags
}

output "vm_name" {
  value       = azurerm_linux_virtual_machine.linux_virtual_machine.name
  description = "The name of the virtual machine."
}

output "vm_public_ip" {
  value       = azurerm_public_ip.public_ip.ip_address
  description = "The public IP address of the virtual machine."
}