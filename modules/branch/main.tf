locals {
  branch_config = {
    for pair in setproduct(var.repositories, var.branches) : 
    "${pair[0]}_${pair[1]}" => {
      repo = pair[0]
      branch = pair[1]
    }
  }
}

resource "github_branch" "branches" {
  for_each   = local.branch_config
  repository = var.repository_names[each.value.repo]
  branch     = each.value.branch
}

resource "github_branch_default" "default_branch" {
  for_each   = toset(var.repositories)
  repository = var.repository_names[each.key]
  branch     = var.default_branch
  
  depends_on = [github_branch.branches]
}

resource "github_branch_protection" "protection" {
  for_each      = var.protected_repos
  repository_id = var.repository_node_ids[each.key]
  pattern       = var.default_branch

  required_status_checks {
    strict   = true
    contexts = []
  }

  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 1
  }
} 