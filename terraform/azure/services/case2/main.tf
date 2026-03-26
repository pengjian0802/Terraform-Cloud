terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "app_service" {
  source               = "../../modules/app_service"
  resource_group_name  = var.resource_group_name
  app_service_region   = var.app_service_region
  app_service_name     = var.app_service_name
  app_service_sku_name = var.app_service_sku_name
  app_service_tags     = var.app_service_tags
  application_stack    = var.application_stack
}
