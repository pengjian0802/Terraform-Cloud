terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_resource_group" "app_service_rg" {
  name     = var.app_service_rg_name
  location = var.app_service_region
  tags     = var.app_service_tags
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "${var.app_service_name}-plan"
  location            = var.app_service_region
  resource_group_name = azurerm_resource_group.app_service_rg.name
  os_type             = "Linux"
  sku_name            = var.app_service_sku_name
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.app_service_rg.name
  location            = azurerm_service_plan.app_service_plan.location
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