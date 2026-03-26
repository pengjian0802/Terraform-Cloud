variable "sp_client_id" {
  type        = string
  description = "Azure Service Principal Client ID"
}

variable "resource_group_name" {
  type        = string
  description = "ARO Resource Group Name"
  default     = "aro-dev-rg"
}

variable "cluster_name" {
  type        = string
  description = "ARO Cluster Name (lowercase, numbers, hyphens, 3-63 chars)"
  validation {
    condition     = length(var.cluster_name) >= 3 && length(var.cluster_name) <= 63
    error_message = "Cluster name length must be between 3-63 characters"
  }
  default = "aro-dev-cluster"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Service     = "ARO"
  }
}

variable "vnet_address_space" {
  type        = list(string)
  description = "VNet Address Space"
  default     = ["10.0.0.0/22"]
}

variable "main_subnet_prefixes" {
  type        = list(string)
  description = "main subnet address prefixes"
  default     = ["10.0.0.0/23"]
}

variable "worker_subnet_prefixes" {
  type        = list(string)
  description = "worker subnet address prefixes"
  default     = ["10.0.2.0/23"]
}

variable "pod_cidr" {
  type        = string
  description = "Pod network CIDR"
  default     = "10.128.0.0/14"
}

variable "service_cidr" {
  type        = string
  description = "Service network CIDR"
  default     = "172.30.0.0/16"
}

variable "master_vm_size" {
  type        = string
  description = "ARO Master Node VM Size"
  default     = "Standard_D8s_v5"
}

variable "worker_vm_size" {
  type        = string
  description = "ARO Worker Node VM Size"
  default     = "Standard_D4s_v5"
}

variable "worker_count" {
  type        = number
  description = "ARO Worker Node Count"
  default     = 3
}

variable "worker_disk_size_gb" {
  type        = number
  description = "ARO Worker Node Disk Size (GB)"
  default     = 128
}

variable "cluster_domain" {
  type        = string
  description = "ARO Cluster Domain Name Prefix"
  default     = "arocluster"
}