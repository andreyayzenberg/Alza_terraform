resource "github_repository" "repos" {
  for_each    = toset(var.repositories)
  name        = each.key
  description = "Repository ${each.key}, part of Alza demo task"
  visibility  = "public"
  auto_init   = true
}

resource "github_repository_file" "readme" {
  for_each = var.repo_languages

  repository = github_repository.repos[each.key].name
  branch     = var.main_branch_name
  file       = "doc/README.md"
  content    = <<-EOT
    repository: ${each.key}
    jazyk: ${each.value}
  EOT
  commit_message = "Add README.md to doc folder"
}

output "repo_names" {
  value = { for k, v in github_repository.repos : k => v.name }
}

output "repo_node_ids" {
  value = { for k, v in github_repository.repos : k => v.node_id }
} 