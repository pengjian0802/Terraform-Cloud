terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

data "azuread_client_config" "current" {}
data "azurerm_subscription" "current_subscription" {}

resource "azuread_application" "application" {
  display_name = var.sp_name
  owners       = [data.azuread_client_config.current.object_id]
}

# Create Service Principal (Core Resource)
resource "azuread_service_principal" "sp" {
  client_id                    = azuread_application.application.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Create Service Principal Password (Client Secret)
resource "azuread_service_principal_password" "sp_password" {
  service_principal_id = azuread_service_principal.sp.id
}

# # Assign Owner Role to Service Principal at Subscription Scope
resource "azurerm_role_assignment" "sp_role" {
  scope                = "/subscriptions/${data.azurerm_subscription.current_subscription.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.sp.object_id
}

# Output Service Principal ID
output "sp_id" {
  value       = azuread_service_principal.sp.object_id
  description = "Service Principal ID"
}

# Output Service Principal Name
output "sp_name" {
  value       = azuread_application.application.display_name
  description = "Service Principal Name"
}

output "sp_key" {
  value       = azuread_service_principal_password.sp_password.value
  description = "Service Principal Key"
  sensitive   = true
}

# Output Service Principal Client ID and Client Secret
output "sp_client_id" {
  value       = azuread_service_principal.sp.client_id
  description = "Service Principal Client ID"
}

output "sp_tenant_id" {
  value       = data.azuread_client_config.current.tenant_id
  description = "SP Tenant ID"
}

output "sp_subscription_id" {
  value       = data.azurerm_subscription.current_subscription.subscription_id
  description = "SP Subscription ID"
}

output "sp_subscription_name" {
  value = data.azurerm_subscription.current_subscription.display_name
  description = "SP Subscription Name"
}
