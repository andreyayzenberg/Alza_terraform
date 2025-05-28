resource "github_repository" "repos" {
  for_each    = toset(var.repositories)
  name        = each.key
  description = "Repository ${each.key}, part of Alza demo task"
  visibility  = "public"
  auto_init   = true
}

output "repo_names" {
  value = { for k, v in github_repository.repos : k => v.name }
}

output "repo_node_ids" {
  value = { for k, v in github_repository.repos : k => v.node_id }
}