# Azure DevOps组织基础配置
variable "azdo_org_name" {
  type        = string
  description = "Azure DevOps Organization Name"
  default     = "gta-org"
}

variable "azdo_pat_token" {
  type        = string
  description = "Azure DevOps PAT Token（Permissions: Security/Project/Code/Pipelines full）"
  sensitive   = true # 敏感变量，不显示在输出/日志中
}

# 多团队核心配置
variable "teams" {
  type = map(object({
    project_administrators = list(string)
    contributors           = list(string)
  }))
  description = "Multi-Team Configuration: key=ProjectName, value=Group-UserEmailMap"
}

variable "env_names" {
  type        = list(string)
  description = "Environment Names"
  default     = ["SandBox", "Dev", "Test", "UAT", "Prod"]
}

variable "reviewer_count" {
  type        = number
  description = "Minimum Number of Reviewers for Pull Requests"
  default     = 1
}

variable "ci_build_id" {
  type        = number
  description = "CI Pipeline ID (for branch build validation)"
  default     = 1
}