variable "resource_group_name" {
  type        = string
  description = "Azure Resource Group Name"
  default     = "gta-devops-rg"
}

variable "sp_client_id" {
  type        = string
  description = "Azure Service Principal Client ID"
}

variable "acr_name_prefix" {
  type        = string
  description = "Azure Container Registry Name Prefix"
}

variable "acr_sku" {
  type        = string
  description = "Azure Container Registry SKU"
  default     = "Standard"
}

variable "cluster_name" {
  type        = string
  description = "Azure ARO Cluster Name"
}

variable "master_vm_size" {
  type        = string
  description = "Azure ARO Master VM Size"
  default     = "Standard_D8s_v5"
}

variable "worker_vm_size" {
  type        = string
  description = "Azure ARO Worker VM Size"
  default     = "Standard_D4s_v5"
}

variable "worker_count" {
  type        = number
  description = "Azure ARO Master Node Count"
  default     = 3
}

variable "worker_disk_size_gb" {
  type        = number
  default     = 128
  description = "Azure ARO Worker Disk Size GB"
}

variable "tags" {
  type        = map(any)
  description = "Azure Resource Tags"
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Service     = "ARO"
  }
}
