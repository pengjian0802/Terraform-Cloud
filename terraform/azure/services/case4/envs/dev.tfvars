sp_client_id = "8005ede7-82c2-42d4-acbc-ff0a9005e303"
resource_group_name = "gta-devops-rg"
acr_name_prefix = "acrdevops"
acr_sku = "Basic"
key_vault_name = "ocp-guide-vm-kv"
guide_vm_instance = {
  vm_name = "ocp-vm-guide"
  vm_size = "Standard_D2s_v3"
  vm_image = {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9_7"
    version   = "9.7.2026012716"
  },
  ocp_config = {
    base_domain     = "gta-ocp-cluster.net"
    cluster_name    = "ocp-cluster"
    location        = "eastasia"
    base_domain_rg  = "gta-ocp-cluster-rg"
    master_replicas = 3
    master_size     = "Standard_B2s"
    worker_replicas = 3
    worker_size     = "Standard_B1s"
  }
}
tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  Service        = "OCP"
}
