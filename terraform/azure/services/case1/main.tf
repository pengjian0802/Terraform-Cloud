terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.15.0"
    }
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

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/${var.azdo_org_name}/"
  personal_access_token = var.azdo_pat_token
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

# 批量创建多团队项目
module "azure_devops" {
  for_each          = var.teams
  source            = "../../modules/devops"
  azdo_org_name     = var.azdo_org_name
  azdo_pat_token    = var.azdo_pat_token
  project_name      = each.key
  team              = each.value
  sp_client_id      = module.sp.sp_client_id
  sp_key            = module.sp.sp_key
  sp_tenant_id      = module.sp.sp_tenant_id
  subscription_id   = module.sp.sp_subscription_id
  subscription_name = module.sp.sp_subscription_name
  azure_rm_sc_name  = var.azure_rm_sc_name

  providers = {
    azuredevops = azuredevops
  }
}
