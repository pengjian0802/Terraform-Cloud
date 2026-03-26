output "ACR_SUMMARY" {
  value = {
    acr_name         = module.acr.acr_name
    acr_login_server = module.acr.acr_login_server
  }
  description = "ACR Summary"
}

output "ARO_SUMMARY" {
  value = {
    aro_cluster_name           = module.aro.cluster_name
    aro_cluster_console_url    = module.aro.cluster_console_url
    aro_cluster_api_server_url = module.aro.cluster_api_server_url
    aro_cluster_username       = module.aro.cluster_username
    aro_cluster_password       = module.aro.cluster_password
  }
  description = "ARO cluster Summary"
}
