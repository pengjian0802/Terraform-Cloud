variable "project_name" {
  type        = string
  description = "Azure DevOps Project Name"
}
variable "project_id" {
  type        = string
  description = "Azure DevOps Project ID"
}
variable "env_names" {
  type        = list(string)
  description = "Environment Names List"
  default     = ["SandBox", "Dev", "UAT", "Prod"]
}