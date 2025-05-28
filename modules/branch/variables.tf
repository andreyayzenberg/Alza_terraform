variable "repositories" {
  type        = list(string)
  description = "List of repository names"
}

variable "branches" {
  type        = list(string)
  description = "List of branch names to create"
}

variable "default_branch" {
  type        = string
  description = "Name of the default branch"
}

variable "repository_names" {
  type        = map(string)
  description = "Map of repository names"
}

variable "repository_node_ids" {
  type        = map(string)
  description = "Map of repository node IDs"
}

variable "protected_repos" {
  type        = set(string)
  description = "Set of repository names that should have branch protection"
  default     = []
}

variable "repo_languages" {
  type        = map(string)
  description = "Map of repository names to their programming languages"
} 