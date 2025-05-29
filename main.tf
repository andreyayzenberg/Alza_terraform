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

variable "repo_xxx" {
  type        = string
  description = "Name for the first repository"
}

variable "repo_yyy" {
  type        = string
  description = "Name for the second repository"
}

variable "repo_zzz" {
  type        = string
  description = "Name for the third repository"
}

locals {
  repositories = [var.repo_xxx, var.repo_yyy, var.repo_zzz]
  branches     = ["main", "mojeDefaultBranch"]
  environments = ["dev", "test", "produkce"]

  repo_languages = {
    "${var.repo_xxx}" = "sql"
    "${var.repo_yyy}" = "java"
    "${var.repo_zzz}" = "sql"
  }
}

module "repository" {
  source       = "./modules/repository"
  repositories = local.repositories
}

module "branch" {
  source = "./modules/branch"

  repositories        = local.repositories
  branches            = local.branches
  default_branch      = "mojeDefaultBranch"
  repository_names    = module.repository.repo_names
  repository_node_ids = module.repository.repo_node_ids
  protected_repos     = toset(["xxx"])
  repo_languages      = local.repo_languages

  depends_on = [module.repository]
}

module "environment" {
  source = "./modules/environment"

  environments     = local.environments
  repositories     = local.repositories
  repository_names = module.repository.repo_names

  depends_on = [module.repository]
}
