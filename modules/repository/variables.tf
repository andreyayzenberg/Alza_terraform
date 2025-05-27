variable "repositories" {
  type        = list(string)
  description = "List of repository names to create"
}

variable "repo_languages" {
  type        = map(string)
  description = "Map of repository names to their programming languages"
}

variable "main_branch_name" {
  type        = string
  description = "Name of the main branch"
  default     = "main"
} 