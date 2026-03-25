# Azure DevOps组织配置
azdo_org_name = "gta-org"
azdo_pat_token = "xxxxxxxxxxxxxxxxxxx"
sp_name = "gta-sp"
azure_rm_sc_name = "azure-rm-sc"

# 多团队配置（用户邮箱版）
teams = {
  "Demo" = {
    # Project Administrator
    project_administrators = ["jianpeng@MerivoxA.onmicrosoft.com"],
    # Contributor
    contributors        = ["jianpeng@MerivoxA.onmicrosoft.com"]
  }
}