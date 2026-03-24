data "azurerm_resource_group" "gta-rg" {
  name = var.resource_group_name
}

locals {
  # 基于资源组 ID 生成哈希，转小写后取前8位
  unique_suffix = substr(lower(sha1(data.azurerm_resource_group.gta-rg.id)), 0, 8)
  # 最终 ACR 名称 = 前缀 + 唯一后缀（如 gtaacr8f7e6d5c）
  acr_name = "${var.acr_name_prefix}${local.unique_suffix}"
}

resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.gta-rg.name
  location            = data.azurerm_resource_group.gta-rg.location
  sku                 = var.acr_sku
  admin_enabled       = true

  # 配置镜像保留策略（自动清理旧镜像，节省成本）Premium SKU 才支持保留策略
  #   retention_policy {
  #     enabled = true
  #     days    = 7  # 保留 7 天内的镜像，自动删除更早的
  #   }
}

data "azuread_service_principal" "gta_sp" {
  object_id = var.sp_object_id
}

# 为服务主体分配 AcrPush 角色（包含pull + push）, AcrPull 角色（仅pull）
resource "azurerm_role_assignment" "acr_push" {
  principal_id                     = data.azuread_service_principal.gta_sp.object_id
  role_definition_name             = "AcrPush"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true # 敏感信息，隐藏默认输出
}

output "acr_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true # 管理员密码，敏感信息
}