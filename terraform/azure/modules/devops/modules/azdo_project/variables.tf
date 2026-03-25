variable "project_name" {
  type        = string
  description = "Azure DevOps project name"
}

variable "azdo_org_name" {
  type        = string
  description = "Azure DevOps organization name"
}

variable "azure_rm_sc_name" {
  type        = string
  description = "Azure Resource Manager service connection name"
}

variable "azure_rm_sc_description" {
  type        = string
  description = "Azure Resource Manager service connection description"
  default     = "Manager By Terraform"
}

variable "sp_client_id" {
  type        = string
  description = "Azure Service Principal Client/Application ID"
}

variable "sp_key" {
  type        = string
  description = "Azure Service Principal Key"
 }

 variable "sp_tenant_id" {
  type        = string
  description = "Azure Service Principal Tenant ID"
 }

 variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
 }

 variable "subscription_name" {
  type        = string
  description = "Azure Subscription Name"
 }


