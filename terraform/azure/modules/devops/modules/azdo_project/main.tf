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