locals {
  env_config = merge([
    for env in var.environments : {
      for repo in var.repositories : "${repo}_${env}" => {
        repo = repo
        env  = env
      }
    }
  ]...)
}

resource "github_repository_environment" "envs" {
  for_each = local.env_config

  repository  = var.repository_names[each.value.repo]
  environment = each.value.env
} 