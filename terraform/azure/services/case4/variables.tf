variable "sp_client_id" {
  type        = string
  description = "Service Principal Client ID"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "admin_username" {
  type        = string
  description = "Admin Username"
  default     = "adminuser"
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault Name"
}

variable "guide_vm_instance" {
  type = object({
    vm_name = string
    vm_size = string
    vm_image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }),
    ocp_config = object({
      base_domain     = string
      cluster_name    = string
      location        = string
      base_domain_rg  = string
      master_replicas = number
      master_size     = string
      worker_replicas = number
      worker_size     = string
    })
  })
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Service     = "OCP"
  }
}
