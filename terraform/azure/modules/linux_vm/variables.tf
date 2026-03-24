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

variable "vm_name" {
  type        = string
  description = "VM Name"
}

variable "vm_size" {
  type        = string
  description = "VM Size"
}

# variable "image_plan_name" {
#   type        = string
#   description = "Image Plan Name"
# }

# variable "image_plan_product" {
#   type        = string
#   description = "Image Plan Product"
# }

# variable "image_plan_publisher" {
#   type        = string
#   description = "Image Plan Publisher"
# }

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