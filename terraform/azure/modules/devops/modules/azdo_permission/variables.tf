variable "project_id" {
  type        = string
  description = "Azure DevOps Project ID"
}

variable "project_administrator_users" {
  type        = list(string)
  description = "List of project administrator users"
}

variable "contributor_users" {
  type        = list(string)
  description = "List of contributor users"
}
