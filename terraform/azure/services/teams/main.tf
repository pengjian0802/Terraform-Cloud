terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.13.0"
    }
  }
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/${var.azdo_org_name}/"
  personal_access_token = var.azdo_pat_token
}

# 批量创建多团队项目
module "azure_devops" {
  source = "../../modules/devops"
  azdo_org_name = var.azdo_org_name
  azdo_pat_token = var.azdo_pat_token
  teams = var.teams
}
