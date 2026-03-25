terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.15.0"
    }
  }
}

resource "azuredevops_build_definition" "pipeline" {
  name       = "${var.project_name}-pipeline"
  project_id = var.project_id

  repository {
    repo_type   = "TfsGit"
    repo_id     = var.repo_id
    branch_name = "refs/heads/main"
    yml_path    = "azure-pipelines.yml"
  }
  ci_trigger {
    use_yaml = true
  }
}

# default group: Contributors
data "azuredevops_group" "contributor_group" {
  project_id = var.project_id
  name       = "Contributors"
}

resource "azuredevops_build_definition_permissions" "example" {
  project_id = var.project_id
  principal  = data.azuredevops_group.contributor_group.id

  build_definition_id = azuredevops_build_definition.pipeline.id

  permissions = {
    ViewBuilds       = "Allow"
    EditBuildQuality = "Deny"
    DeleteBuilds     = "Deny"
    StopBuilds       = "Allow"
  }
}

output "build_definition_id" {
  value = azuredevops_build_definition.pipeline.id
}
