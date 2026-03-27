output "ACR_SUMMARY" {
  value = {
    acr_name         = module.acr.acr_name
    acr_login_server = module.acr.acr_login_server
  }
  description = "ACR Summary"
}

# 引导机登录：ssh -i <private-key> <guide-vm-username>@<guide-vm-ip>
# OCP删除命令：openshift-install destroy cluster --dir=/home/adminuser/ocp-install --log-level=debug
output "GUIDE_VM_SUMMARY" {
  value = {
    key_vault_name    = module.key_vaults.key_vault_name
    guide_vm_name     = module.linux_vm_ocp_install.vm_name
    guide_vm_ip       = module.linux_vm_ocp_install.vm_public_ip
    guide_vm_username = var.admin_username
  }
  description = "Guide VM Summary"
}

# 命令输出敏感数据：terraform output -raw SSH_PUBLIC_SUMMARY
output "SSH_PUBLIC_KEY" {
  value       = module.key_vaults.ssh_public_key
  description = "SSH Public Key"
  sensitive   = true
}

# 命令输出敏感数据：terraform output -raw SSH_PRIVATE_SUMMARY
output "SSH_PRIVATE_KEY" {
  value       = module.key_vaults.ssh_private_key
  description = "SSH Private Key"
  sensitive   = true
}

