# 批量创建Dev/UAT/Prod环境
resource "azuredevops_environment" "this" {
  for_each    = toset(var.env_names)
  project_id  = var.project_id
  name        = each.value
  description = "${each.value} Environment - ${var.project_name}（Terraform Managed）"
}

# 输出环境ID
output "env_ids" {
  value = {
    for k, v in azuredevops_environment.this : k => v.id
  }
}