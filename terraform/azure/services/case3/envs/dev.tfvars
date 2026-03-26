resource_group_name = "gta-devops-rg"
# App registrations: https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade
sp_client_id = "8005ede7-82c2-42d4-acbc-ff0a9005e303"
acr_name_prefix = "acrdevops"
acr_sku = "Basic" # Basic(Free 10G), Standard, Premium.

cluster_name = "aro-devops"
master_vm_size = "Standard_D8s_v5"
worker_vm_size = "Standard_D4s_v5"
worker_count = 3
worker_disk_size_gb = 128
