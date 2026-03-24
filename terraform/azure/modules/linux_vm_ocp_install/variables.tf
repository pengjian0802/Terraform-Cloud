variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "resource_location" {
  type        = string
  description = "Resource Location"
}

variable "admin_username" {
  type        = string
  description = "Admin Username"
}

variable "admin_ssh_public_key" {
  type        = string
  description = "Admin SSH Public Key"
}

variable "admin_ssh_private_key" {
  type        = string
  description = "Admin SSH Private Key"
  sensitive   = true
}

variable "vm_name" {
  type        = string
  description = "VM Name"
}

variable "vm_size" {
  type        = string
  description = "VM Size"
}

variable "image_publisher" {
  type        = string
  description = "Image Publisher"
}

variable "image_offer" {
  type        = string
  description = "Image Offer"
}

variable "image_sku" {
  type        = string
  description = "Image SKU"
}

variable "image_version" {
  type        = string
  description = "Image Version"
}

variable "ocp_base_domain" {
  type        = string
  description = "OCP Base Domain"
}

variable "ocp_cluster_name" {
  type        = string
  description = "OCP Cluster Name"
}

variable "ocp_location" {
  type        = string
  description = "OCP Location"
}

variable "ocp_base_domain_rg" {
  type        = string
  description = "OCP Base Domain Resource Group"
}

variable "sp_client_id" {
  type        = string
  description = "Service Principal Client ID"
}

variable "sp_client_secret" {
  type        = string
  description = "Service Principal Client Secret"
  sensitive   = true
}

variable "sp_tenant_id" {
  type        = string
  description = "SP Tenant ID"
}

variable "ocp_master_replicas" {
  type        = number
  description = "OCP Master Replicas"
}

variable "ocp_master_size" {
  type        = string
  description = "OCP Master Size"
}

variable "ocp_worker_replicas" {
  type        = number
  description = "OCP Worker Replicas"
}

variable "ocp_worker_size" {
  type        = string
  description = "OCP Worker Size"
}

variable "ocp_ssh_public_key" {
  type        = string
  description = "OCP SSH Public Key"
}
