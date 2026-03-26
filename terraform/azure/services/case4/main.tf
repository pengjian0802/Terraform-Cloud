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

provider "azuread" {
}


module "key_vaults" {
  source              = "../../modules/key_vaults"
  resource_group_name = var.resource_group_name
  key_vault_name      = var.key_vault_name
  tags                = var.tags
}

# module "linux_vm" {
#   for_each = var.linux_vm_instances
#   source = "./modules/linux_vm"
#   resource_group_name = azurerm_resource_group.resource_group.name
#   resource_location   = azurerm_resource_group.resource_group.location
#   admin_username      = var.admin_username
#   admin_ssh_public_key = module.key_value.ssh_public_key
#   vm_name             = each.key
#   vm_size             = each.value.vm_size
#   image_publisher = each.value.vm_image.publisher
#   image_offer     = each.value.vm_image.offer
#   image_sku       = each.value.vm_image.sku
#   image_version   = each.value.vm_image.version
# }

module "linux_vm_ocp_install" {
  source                = "../../modules/linux_vm_ocp_install"
  resource_group_name   = var.resource_group_name
  admin_username        = var.admin_username
  admin_ssh_public_key  = module.key_vaults.ssh_public_key
  admin_ssh_private_key = module.key_vaults.ssh_private_key
  vm_name               = var.guide_vm_instance.vm_name
  vm_size               = var.guide_vm_instance.vm_size
  image_publisher       = var.guide_vm_instance.vm_image.publisher
  image_offer           = var.guide_vm_instance.vm_image.offer
  image_sku             = var.guide_vm_instance.vm_image.sku
  image_version         = var.guide_vm_instance.vm_image.version
  ocp_base_domain       = var.guide_vm_instance.ocp_config.base_domain
  ocp_cluster_name      = var.guide_vm_instance.ocp_config.cluster_name
  ocp_location          = var.guide_vm_instance.ocp_config.location
  ocp_base_domain_rg    = var.guide_vm_instance.ocp_config.base_domain_rg
  ocp_master_replicas   = var.guide_vm_instance.ocp_config.master_replicas
  ocp_master_size       = var.guide_vm_instance.ocp_config.master_size
  ocp_worker_replicas   = var.guide_vm_instance.ocp_config.worker_replicas
  ocp_worker_size       = var.guide_vm_instance.ocp_config.worker_size
  ocp_ssh_public_key    = module.key_vaults.ssh_public_key
  sp_client_id          = var.sp_client_id
  #   sp_client_secret      = module.sp.sp_client_secret
  #   sp_tenant_id          = module.sp.sp_tenant_id
  tags = var.tags
}