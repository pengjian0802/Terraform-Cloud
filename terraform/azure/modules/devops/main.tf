terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.15.0"
    }
  }
}

# 批量创建多团队项目
module "azdo_project" {
  source        = "./modules/azdo_project"
  project_name  = var.project_name
  azdo_org_name = var.azdo_org_name
  azure_rm_sc_name = var.azure_rm_sc_name
  sp_client_id = var.sp_client_id
  sp_key = var.sp_key
  sp_tenant_id = var.sp_tenant_id
  subscription_id = var.subscription_id
  subscription_name = var.subscription_name
}

# 批量配置多团队权限（项目+环境）
module "azdo_permission" {
  source                      = "./modules/azdo_permission"
  project_id                  = module.azdo_project.project_id
  project_administrator_users = var.team.project_administrators
  contributor_users           = var.team.contributors
}

module "azdo_build_defined" {
  source = "./modules/azdo_build_defined"
  project_name = var.project_name
  project_id = module.azdo_project.project_id
  repo_id    = module.azdo_project.repo_id
}

# 批量配置多团队分支保护策略
module "azdo_branch_policy" {
  source         = "./modules/azdo_branch_policy"
  project_name   = var.project_name
  project_id     = module.azdo_project.project_id
  repo_id        = module.azdo_project.repo_id
  reviewer_count = var.reviewer_count
  ci_build_id    = module.azdo_build_defined.build_definition_id
  author_email   = var.team.project_administrators[0]
}

# 批量创建多团队环境
module "azdo_environment" {
  source       = "./modules/azdo_environment"
  project_name = var.project_name
  project_id   = module.azdo_project.project_id
  env_names    = var.env_names
}

output "project_id" {
  value = module.azdo_project.project_id
  description = "Azure DevOps Project ID"
}

output "project_name" {
  value = var.project_name
  description = "Azure DevOps Project Name"
}

output "project_url" {
  value = module.azdo_project.project_url
  description = "Azure DevOps Project URL"
}

output "repo_id" {
  value = module.azdo_project.repo_id
  description = "Azure DevOps Repository ID"
}
