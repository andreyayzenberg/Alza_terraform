variable "repositories" {
  type        = list(string)
  description = "List of repository names to create"
}

variable "main_branch_name" {
  type        = string
  description = "Name of the main branch"
  default     = "main"
} 