data "azuread_client_config" "current" {}
data "azurerm_subscription" "current_subscription" {}

resource "azuread_application" "application" {
  display_name = var.sp_name
  owners       = [data.azuread_client_config.current.object_id]
}

# Create Service Principal (Core Resource)
resource "azuread_service_principal" "ocp_sp" {
  client_id                    = azuread_application.application.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Create Service Principal Password (Client Secret)
resource "azuread_service_principal_password" "ocp_sp_password" {
  service_principal_id = azuread_service_principal.ocp_sp.id
}

# # Assign Owner Role to Service Principal at Subscription Scope
resource "azurerm_role_assignment" "ocp_sp_role" {
  scope                = "/subscriptions/${data.azurerm_subscription.current_subscription.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.ocp_sp.object_id
}

# Output Service Principal Client ID and Client Secret
output "sp_client_id" {
  value       = azuread_service_principal.ocp_sp.client_id
  description = "Service Principal Client ID"
}

output "sp_client_secret" {
  value       = azuread_service_principal_password.ocp_sp_password.value
  description = "Service Principal Client Secret"
  sensitive   = true
}

output "sp_tenant_id" {
  value       = data.azuread_client_config.current.tenant_id
  description = "SP Tenant ID"
}