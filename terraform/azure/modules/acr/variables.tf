variable "resource_group_name" {
  type        = string
  description = "Azure Resource Group Name"
  default     = "gta-devops-rg"
}

variable "sp_object_id" {
  type        = string
  description = "Azure Service Principal Object ID"
}

variable "acr_name_prefix" {
  type        = string
  description = "Azure Container Registry Name Prefix"
}

variable "acr_sku" {
  type        = string
  description = "Azure Container Registry SKU"
  default     = "Basic" # 基本SKU，免费; Premium 高级SKU，需要订阅
}
