# Get current tenant ID
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = "${var.resource_group_name}-key-vault"
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    key_permissions    = ["Create", "Get", "List"]
    secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
  }
}

resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  # Get OpenSSH format public key (required by Azure VM)
  ssh_public_key_openssh = tls_private_key.rsa_key.public_key_openssh
  # PEM format private key (for backup)
  ssh_private_key_pem = tls_private_key.rsa_key.private_key_pem
}

# 
resource "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "${var.resource_group_name}-ssh-public-key"
  value        = local.ssh_public_key_openssh
  key_vault_id = azurerm_key_vault.key_vault.id

  tags = {
    purpose = "CP4I VM SSH Public Key"
  }
}

# 存储 SSH 私钥到 Key Vault（备份，敏感信息）
resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "${var.resource_group_name}-ssh-private-key"
  value        = local.ssh_private_key_pem
  key_vault_id = azurerm_key_vault.key_vault.id

  tags = {
    purpose = "CP4I VM SSH Private Key"
  }
}

output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.key_vault.id
}

output "ssh_public_key_name" {
  description = "The name of the SSH public key secret stored in the Key Vault."
  value       = azurerm_key_vault_secret.ssh_public_key.name
}

output "ssh_public_key" {
  description = "The SSH public key stored in the Key Vault."
  value       = azurerm_key_vault_secret.ssh_public_key.value
}

output "ssh_private_key_name" {
  description = "The name of the SSH private key secret stored in the Key Vault."
  value       = azurerm_key_vault_secret.ssh_private_key.name
}

output "ssh_private_key" {
  description = "The SSH private key stored in the Key Vault."
  value       = azurerm_key_vault_secret.ssh_private_key.value
  sensitive   = true
}
