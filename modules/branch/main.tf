locals {
  branch_config = {
    for pair in setproduct(var.repositories, var.branches) : 
    "${pair[0]}_${pair[1]}" => {
      repo = pair[0]
      branch = pair[1]
    }
  }
}

# Step 1: Create all branches
resource "github_branch" "branches" {
  for_each   = local.branch_config
  repository = var.repository_names[each.value.repo]
  branch     = each.value.branch
}

# Step 2: Wait for branches to be fully created
resource "time_sleep" "wait_for_branches" {
  depends_on = [github_branch.branches]
  create_duration = "20s"  # Increased wait time to ensure branches are ready
}

# Step 3: Create README files in main branch only after both branches exist
resource "github_repository_file" "readme" {
  for_each = var.repo_languages

  repository = var.repository_names[each.key]
  branch     = "main"  # Explicitly using main branch
  file       = "doc/README.md"
  content    = <<-EOT
    repository: ${each.key}
    jazyk: ${each.value}
  EOT
  commit_message = "Add README.md to doc folder"

  depends_on = [time_sleep.wait_for_branches]  # Ensure both branches exist before creating README
}

# Step 4: Set default branch after README is created
resource "github_branch_default" "default_branch" {
  for_each   = toset(var.repositories)
  repository = var.repository_names[each.key]
  branch     = var.default_branch
  
  depends_on = [github_repository_file.readme]  # Wait for README to be created before changing default branch
}

# Step 5: Apply branch protection rules
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

  restrictions {
    users = []
    teams = []
  }

  depends_on = [github_branch_default.default_branch]
} 