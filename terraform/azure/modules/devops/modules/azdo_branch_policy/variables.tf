variable "project_name" {
  type        = string
  description = "Azure DevOps Project Name"
}
variable "project_id" {
  type        = string
  description = "Azure DevOps Project ID"
}
variable "repo_id" {
  type        = string
  description = "Azure DevOps Repository ID"
}
variable "reviewer_count" {
  type        = number
  description = "PR Reviewer Count"
  default     = 1
}
variable "ci_build_id" {
  type        = number
  description = "CI Pipeline ID for Branch Validation"
}
variable "author_email" {
  type        = string
  description = "Author Email for Branch Validation"
}