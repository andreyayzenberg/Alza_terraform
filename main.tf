# main.tf

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

locals {
  repositories = ["xxx", "yyy", "zzz"]
  branches    = ["main", "mojeDefaultBranch"]
  environments = ["dev", "test", "produkce"]
  
  repo_languages = {
    xxx = "sql"
    yyy = "java"
    zzz = "sql"
  }
}

module "repository" {
  source = "./modules/repository"
  
  repositories    = local.repositories
  repo_languages = local.repo_languages
  main_branch_name = "main"
}

module "branch" {
  source = "./modules/branch"
  
  repositories        = local.repositories
  branches           = local.branches
  default_branch     = "mojeDefaultBranch"
  repository_names   = module.repository.repo_names
  repository_node_ids = module.repository.repo_node_ids
  protected_repos    = toset(["xxx"])

  depends_on = [module.repository]
}

module "environment" {
  source = "./modules/environment"
  
  environments     = local.environments
  repositories    = local.repositories
  repository_names = module.repository.repo_names

  depends_on = [module.repository]
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "GitHub personal access token"
}

variable "github_owner" {
  type        = string
  description = "GitHub owner/organization name"
}
