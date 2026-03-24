resource "azuredevops_user_entitlement" "project_admins" {
  for_each       = toset(var.project_administrator_users)
  principal_name = each.value
}

resource "azuredevops_user_entitlement" "contributors" {
  for_each       = toset(var.contributor_users)
  principal_name = each.value
}

# default group: Project Administrators
data "azuredevops_group" "project_administrators_group" {
  project_id = var.project_id
  name       = "Project Administrators"
}

# default group: Contributors
data "azuredevops_group" "contributor_group" {
  project_id = var.project_id
  name       = "Contributors"
}

resource "azuredevops_group_membership" "add_administrators" {
  group   = data.azuredevops_group.project_administrators_group.descriptor
  members = [for user in azuredevops_user_entitlement.project_admins : user.descriptor]
}

resource "azuredevops_group_membership" "add_contributors" {
  group   = data.azuredevops_group.contributor_group.descriptor
  members = [for user in azuredevops_user_entitlement.contributors : user.descriptor]
}