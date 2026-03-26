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

provider "azurerm" {
  features {}
}

module "acr" {
  source              = "../../modules/acr"
  resource_group_name = var.resource_group_name
  acr_name_prefix     = var.acr_name_prefix
  acr_sku             = var.acr_sku
  sp_client_id        = var.sp_client_id
  tags                = var.tags
}

module "aro" {
  source              = "../../modules/aro"
  sp_client_id        = var.sp_client_id
  resource_group_name = var.resource_group_name
  cluster_name        = var.cluster_name
  master_vm_size      = var.master_vm_size
  worker_vm_size      = var.worker_vm_size
  worker_count        = var.worker_count
  worker_disk_size_gb = var.worker_disk_size_gb
  tags                = var.tags
}