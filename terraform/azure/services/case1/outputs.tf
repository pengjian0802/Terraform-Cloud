output "SP_SUMMARY" {
  value = {
    sp_id                = module.sp.sp_id
    sp_name              = module.sp.sp_name
    sp_tenant_id         = module.sp.sp_tenant_id
    sp_client_id         = module.sp.sp_client_id
    sp_subscription_id   = module.sp.sp_subscription_id
    sp_subscription_name = module.sp.sp_subscription_name
  }
  description = "Azure Service Principal Summary/ID/Name/Key"
}

output "sp_key" {
  value       = module.sp.sp_key
  description = "Service Principal Key"
  sensitive   = true
}

output "AZURE_DEVOPS_TEAMS_SUMMARY" {
  value = {
    for team in keys(var.teams) : team => {
      project_name = team
      project_id   = module.azure_devops[team].project_id
      project_url  = module.azure_devops[team].project_url
      repo_id      = module.azure_devops[team].repo_id
    }
  }
  description = "Azure DevOps Project Name/ID/URL/Repository ID"
}