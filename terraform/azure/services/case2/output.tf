output "app_service_name" {
  value       = module.app_service.app_service_name
  description = "Azure App Service Name"
}

output "app_service_hostname" {
  value       = module.app_service.app_service_hostname
  description = "Azure App Service Hostname"
}

output "app_service_slot_name" {
  value       = module.app_service.app_service_slot_name
  description = "Azure App Service Slot Name"
}

output "app_service_slot_hostname" {
  value       = module.app_service.app_service_slot_hostname
  description = "Azure App Service Slot Hostname"
}
