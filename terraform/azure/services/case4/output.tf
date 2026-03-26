output "GUIDE_VM_SUMMARY" {
  value = {
    key_vault_name    = module.key_vaults.key_vault_name
    guide_vm_name     = module.linux_vm_ocp_install.vm_name
    guide_vm_ip       = module.linux_vm_ocp_install.vm_public_ip
    guide_vm_username = var.admin_username
  }
}

# 命令输出敏感数据：terraform output -raw SSH_KEY_SUMMAYR
output "SSH_KEY_SUMMAYR" {
  value = {
    ssh_public_key  = module.key_vaults.ssh_public_key
    ssh_private_key = module.key_vaults.ssh_private_key
  }
  sensitive   = true
  description = "The SSH public and private keys stored in the Key Vault."
}
