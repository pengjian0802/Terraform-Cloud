variable "resource_group_name" {
  description = "Azure Resource Group Name"
  type        = string
}

variable "key_vault_name" {
  description = "Key Vault Name"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Service     = "GTA"
  }
}
