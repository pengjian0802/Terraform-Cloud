terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.15.0"
    }
  }
}

resource "azuredevops_branch_policy_merge_types" "branch_merge_policy" {
  project_id = var.project_id
  enabled    = true
  blocking   = true

  settings {
    allow_squash                  = true
    allow_rebase_and_fast_forward = true
    allow_basic_no_fast_forward   = true
    allow_rebase_with_merge       = true

    scope {
      repository_id  = var.repo_id
      repository_ref = "refs/heads/main"
      match_type     = "Exact"
    }

    scope {
      repository_id  = null # All repositories in the project
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

resource "azuredevops_branch_policy_build_validation" "build_validation_policy" {
  project_id = var.project_id

  enabled  = true
  blocking = true

  settings {
    display_name                = "Build validation policy"
    build_definition_id         = var.ci_build_id
    queue_on_source_update_only = true
    valid_duration              = 720
    filename_patterns = [
      "/WebApp/*",
      "!/WebApp/Tests/*",
      "*.cs"
    ]

    scope {
      repository_id  = var.repo_id
      repository_ref = "refs/heads/main"
      match_type     = "Exact"
    }

    scope {
      repository_id  = var.repo_id
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

resource "azuredevops_branch_policy_min_reviewers" "min_reviewers_policy" {
  project_id = var.project_id
  enabled    = true
  blocking   = true

  settings {
    reviewer_count                         = var.reviewer_count
    submitter_can_vote                     = false
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = true

    scope {
      repository_id  = var.repo_id
      repository_ref = "refs/heads/main"
      match_type     = "Exact"
    }

    scope {
      repository_id  = null
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

resource "azuredevops_user_entitlement" "author" {
  principal_name       = var.author_email
  account_license_type = "basic"
}

resource "azuredevops_branch_policy_status_check" "status_check_policy" {
  project_id = var.project_id

  enabled  = true
  blocking = true

  settings {
    name                 = "Release"
    author_id            = azuredevops_user_entitlement.author.id
    invalidate_on_update = true
    applicability        = "conditional"
    display_name         = "PreCheck"

    scope {
      repository_id  = var.repo_id
      repository_ref = "refs/heads/main"
      match_type     = "Exact"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

resource "azuredevops_branch_policy_work_item_linking" "work_item_linking_policy" {
  project_id = var.project_id

  enabled  = true
  blocking = true

  settings {

    scope {
      repository_id  = var.repo_id
      repository_ref = "refs/heads/main"
      match_type     = "Exact"
    }

    scope {
      repository_id  = var.repo_id
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}