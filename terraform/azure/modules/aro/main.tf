terraform {
  required_version = ">= 1.5.0"

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

data "azuread_service_principal" "gta_sp" {
  client_id = var.sp_client_id
}

resource "azuread_service_principal_password" "service_principal_password" {
  service_principal_id = "/servicePrincipals/${data.azuread_service_principal.gta_sp.object_id}"
}

# Red Hat OpenShift Service Principal(This is the Azure Red Hat OpenShift RP service principal id, do NOT delete it)
data "azuread_service_principal" "redhat_openshift" {
  client_id = "f1dd0a37-89c6-4e07-bcd1-ffd3d43d8875"
}

resource "azurerm_role_assignment" "role_network1" {
  scope                = azurerm_virtual_network.virtual_network.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.gta_sp.object_id
}

resource "azurerm_role_assignment" "role_network2" {
  scope                = azurerm_virtual_network.virtual_network.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.redhat_openshift.object_id
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "role_resource_group" {
  scope                = data.azurerm_resource_group.resource_group.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.gta_sp.object_id
}

# Create the virtual network for ARO cluster
resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.cluster_name}-vnet"
  address_space       = var.vnet_address_space
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = var.tags
}

# Create the subnet for ARO master nodes
resource "azurerm_subnet" "main_subnet" {
  name                 = "${var.cluster_name}-main-subnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.main_subnet_prefixes
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]

  depends_on = [azurerm_virtual_network.virtual_network]
}

# Create the subnet for ARO worker nodes
resource "azurerm_subnet" "worker_subnet" {
  name                 = "${var.cluster_name}-worker-subnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.worker_subnet_prefixes
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]

  depends_on = [azurerm_virtual_network.virtual_network]
}

# 4. 创建 ARO 集群（核心资源）
resource "azurerm_redhat_openshift_cluster" "aro_cluster" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  cluster_profile {
    domain  = var.cluster_domain
    version = "4.19.20"
  }

  network_profile {
    pod_cidr     = var.pod_cidr
    service_cidr = var.service_cidr
  }

  main_profile {
    vm_size   = var.master_vm_size
    subnet_id = azurerm_subnet.main_subnet.id
  }

  api_server_profile {
    visibility = "Public"
  }

  ingress_profile {
    visibility = "Public"
  }

  worker_profile {
    vm_size      = var.worker_vm_size
    node_count   = var.worker_count
    disk_size_gb = var.worker_disk_size_gb
    subnet_id    = azurerm_subnet.worker_subnet.id
  }

  service_principal {
    client_id     = data.azuread_service_principal.gta_sp.client_id
    client_secret = azuread_service_principal_password.service_principal_password.value
  }

  depends_on = [azurerm_role_assignment.role_network1, azurerm_role_assignment.role_network2]

  # 标签配置
  tags = var.tags
}

output "cluster_name" {
  value = azurerm_redhat_openshift_cluster.aro_cluster.name
  description = "ARO cluster name"
}

output "cluster_console_url" {
  value = azurerm_redhat_openshift_cluster.aro_cluster.console_url
  description = "ARO cluster console URL"
}

output "cluster_api_server_url" {
  value = azurerm_redhat_openshift_cluster.aro_cluster.api_server_profile[0].url
  description = "ARO cluster API server URL"
}

output "cluster_username" {
  value = "kubeadmin"
  description = "ARO cluster username"
}

output "cluster_password" {
  value = "az aro list-credentials --name <cluster_name> --resource-group <resource_group_name>"
  description = "ARO cluster password"
}

# Outputs for kubeadmin username and password
# az aro list-credentials --name <cluster_name> --resource-group <resource_group_name>
