variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "app_service_region" {
  type        = string
  description = "Azure App Service Region"
  default     = "eastasia"
}

variable "app_service_sku_name" {
  type        = string
  description = "Azure App Service SKU Name"
  default     = "F1" # Free F1 can not be used for slot
}

variable "app_service_name" {
  type        = string
  description = "Azure App Service Name"
}

variable "application_stack" {
  type = object({
    type                = string           # python/nodejs/dotnet/java
    version             = string           # 3.11/18-lts/7.0/17
    java_server         = optional(string) # Java:（TOMCAT/JETTY）
    java_server_version = optional(string) # Java: Container Version
  })
  default = {
    type    = "python"
    version = "3.11"
  }
  description = "App Service application stack configuration"
}

variable "app_service_tags" {
  type        = map(string)
  description = "Tags to apply to the App Service resources"
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Service     = "AppService"
  }
}
