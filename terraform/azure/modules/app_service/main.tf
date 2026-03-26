terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "${var.app_service_name}-plan"
  location            = var.app_service_region
  resource_group_name = data.azurerm_resource_group.resource_group.name
  os_type             = "Linux"
  sku_name            = var.app_service_sku_name
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                = var.app_service_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = var.app_service_region
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    # 1. Python 运行时（仅当 type = "python" 时生效）
    dynamic "application_stack" {
      for_each = var.application_stack.type == "python" ? [var.application_stack] : []
      content {
        python_version = application_stack.value.version
      }
    }

    # 2. Node.js 运行时（仅当 type = "nodejs" 时生效）
    dynamic "application_stack" {
      for_each = var.application_stack.type == "nodejs" ? [var.application_stack] : []
      content {
        node_version = application_stack.value.version
      }
    }

    # 3. .NET 运行时（仅当 type = ".net" 时生效）
    dynamic "application_stack" {
      for_each = var.application_stack.type == ".net" ? [var.application_stack] : []
      content {
        dotnet_version = application_stack.value.version
      }
    }

    # 4. Java 运行时（仅当 type = "java" 时生效）
    dynamic "application_stack" {
      for_each = var.application_stack.type == "java" ? [var.application_stack] : []
      content {
        java_version        = application_stack.value.version
        java_server         = application_stack.value.java_server
        java_server_version = application_stack.value.java_server_version
      }
    }

    health_check_path = "/health"
  }

  tags = var.app_service_tags
}

resource "azurerm_linux_web_app_slot" "linux_web_app_slot" {
  name                = "staging-slot"
  app_service_id      = azurerm_linux_web_app.linux_web_app.id

  site_config {
    # 1. Python 运行时（仅当 type = "python" 时生效）
    dynamic "application_stack" {
      for_each = var.application_stack.type == "python" ? [var.application_stack] : []
      content {
        python_version = application_stack.value.version
      }
    }

    # 2. Node.js 运行时（仅当 type = "nodejs" 时生效）
    dynamic "application_stack" {
      for_each = var.application_stack.type == "nodejs" ? [var.application_stack] : []
      content {
        node_version = application_stack.value.version
      }
    }

    # 3. .NET 运行时（仅当 type = ".net" 时生效）
    dynamic "application_stack" {
      for_each = var.application_stack.type == ".net" ? [var.application_stack] : []
      content {
        dotnet_version = application_stack.value.version
      }
    }

    # 4. Java 运行时（仅当 type = "java" 时生效）
    dynamic "application_stack" {
      for_each = var.application_stack.type == "java" ? [var.application_stack] : []
      content {
        java_version        = application_stack.value.version
        java_server         = application_stack.value.java_server
        java_server_version = application_stack.value.java_server_version
      }
    }
    
    health_check_path = "/health"
  }
}

output "app_service_name" {
  value       = azurerm_linux_web_app.linux_web_app.name
  description = "Azure App Service Name"
}

output "app_service_hostname" {
  value       = azurerm_linux_web_app.linux_web_app.default_hostname
  description = "Azure App Service URL"
}

output "app_service_slot_name" {
  value       = azurerm_linux_web_app_slot.linux_web_app_slot.name
  description = "Azure App Service Slot Name"
}

output "app_service_slot_hostname" {
  value       = azurerm_linux_web_app_slot.linux_web_app_slot.default_hostname
  description = "Azure App Service Slot Hostname"
}

