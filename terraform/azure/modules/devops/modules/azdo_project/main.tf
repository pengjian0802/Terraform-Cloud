terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.15.0"
    }
  }
}

resource "azuredevops_project" "azdo_project" {
  name               = var.project_name
  description        = "${var.project_name} project created by Terraform"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
  features = {
    boards       = "enabled"
    repositories = "enabled"
    pipelines    = "enabled"
    testplans    = "enabled"
    artifacts    = "enabled"
  }
}

# The Default Git repository after the project is created
data "azuredevops_git_repository" "repository" {
  name       = azuredevops_project.azdo_project.name
  project_id = azuredevops_project.azdo_project.id
}

resource "azuredevops_serviceendpoint_azurerm" "azure_rm_sc" {
  project_id                             = azuredevops_project.azdo_project.id
  service_endpoint_name                  = var.azure_rm_sc_name
  description                            = var.azure_rm_sc_description
  service_endpoint_authentication_scheme = "ServicePrincipal"
  credentials {
    serviceprincipalid  = var.sp_client_id
    serviceprincipalkey = var.sp_key
  }
  azurerm_spn_tenantid      = var.sp_tenant_id
  azurerm_subscription_id   = var.subscription_id
  azurerm_subscription_name = var.subscription_name
}

# 输出项目信息
output "project_id" {
  value = azuredevops_project.azdo_project.id
}

output "project_url" {
  value = "https://dev.azure.com/${var.azdo_org_name}/${azuredevops_project.azdo_project.name}"
}

output "repo_id" {
  value = data.azuredevops_git_repository.repository.id
}