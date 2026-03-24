# 批量创建多团队项目
module "azure_devops" {
  for_each      = var.teams
  source        = "./modules/azdo_project"
  project_name  = each.key
  azdo_org_name = var.azdo_org_name

  providers = {
    azuredevops = azuredevops
  }
}

# 批量配置多团队权限（项目+环境）
module "azdo_permission" {
  for_each                    = var.teams
  source                      = "./modules/azdo_permission"
  project_id                  = module.azdo_project[each.key].project_id
  project_administrator_users = each.value.project_administrators
  contributor_users           = each.value.contributors

  providers = {
    azuredevops = azuredevops
  }
}

module "azdo_build_defined" {
  for_each = var.teams
  source = "./modules/azdo_build_defined"
  project_name = each.key
  project_id = module.azdo_project[each.key].project_id
  repo_id    = module.azdo_project[each.key].repo_id

  providers = {
    azuredevops = azuredevops
  }
}

# 批量配置多团队分支保护策略
module "azdo_branch_policy" {
  for_each       = var.teams
  source         = "./modules/azdo_branch_policy"
  project_name   = each.key
  project_id     = module.azdo_project[each.key].project_id
  repo_id        = module.azdo_project[each.key].repo_id
  reviewer_count = var.reviewer_count
  ci_build_id    = module.azdo_build_defined[each.key].build_definition_id
  author_email   = each.value.project_administrators[0]

  providers = {
    azuredevops = azuredevops
  }
}

# 批量创建多团队环境
module "azdo_environment" {
  for_each     = var.teams
  source       = "./modules/azdo_environment"
  project_name = each.key
  project_id   = module.azdo_project[each.key].project_id
  env_names    = var.env_names

  providers = {
    azuredevops = azuredevops
  }
}