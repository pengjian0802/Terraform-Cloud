# 输出所有项目信息
output "AZURE_DEVOPS_PROJECT_SUMMARY" {
  value = {
    for team in keys(var.teams) : team => {
      project_name = team
      project_id   = module.azdo_project[team].project_id
      project_url  = module.azdo_project[team].project_url
      repo_id      = module.azdo_project[team].repo_id
    }
  }
  description = "Azure DevOps Project Name/ID/URL/Repository ID"
}