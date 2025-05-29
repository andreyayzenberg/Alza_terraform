# main.tf

provider "github" {
  token    = var.github_token # Personal access token
  owner    = var.github_owner # GitHub owner/organization name
  base_url = "https://api.github.com/"
}

# Variable declarations
variable "github_token" {
  type        = string
  sensitive   = true
  description = "GitHub Personal Access Token"
}

variable "github_owner" {
  type        = string
  description = "GitHub owner/organization name"
}

variable "repositories" {
  type        = list(string)
  description = "List of repository names, defined in terraform-manual.yml"
}

locals {
  branches     = ["main", "mojeDefaultBranch"]
  environments = ["dev", "test", "produkce"]

  repo_languages = {
    for repo in var.repositories : repo => repo == var.repositories[1] ? "java" : "sql"
  }
}

module "repository" {
  source       = "./modules/repository"
  repositories = var.repositories
}

module "branch" {
  source = "./modules/branch"

  repositories        = var.repositories
  branches            = local.branches
  default_branch      = "mojeDefaultBranch"
  repository_names    = module.repository.repo_names
  repository_node_ids = module.repository.repo_node_ids
  protected_repos     = toset([var.repositories[0]])
  repo_languages      = local.repo_languages

  depends_on = [module.repository]
}

module "environment" {
  source = "./modules/environment"

  environments     = local.environments
  repositories     = var.repositories
  repository_names = module.repository.repo_names

  depends_on = [module.repository]
}
