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

module "sp" {
  source  = "../../modules/service_principal"
  sp_name = var.sp_name

  providers = {
    azurerm = azurerm
    azuread = azuread
  }
}

output "sp_id" {
  value       = module.sp.sp_id
  description = "Service Principal ID"
}

output "sp_name" {
  value       = module.sp.sp_name
  description = "Service Principal Name"
}

output "sp_key" {
  value       = module.sp.sp_key
  description = "Service Principal Key"
  sensitive   = true
}

output "sp_tenant_id" {
  value       = module.sp.sp_tenant_id
  description = "Service Principal Tenant ID"
}

output "sp_client_id" {
  value       = module.sp.sp_client_id
  description = "Service Principal Client ID"
}

output "sp_subscription_id" {
  value       = module.sp.sp_subscription_id
  description = "Service Principal Subscription ID"
}

output "sp_subscription_name" {
  value       = module.sp.sp_subscription_name
  description = "Service Principal Subscription Name"
}
