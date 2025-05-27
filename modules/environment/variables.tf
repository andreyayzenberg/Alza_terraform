variable "environments" {
  type        = list(string)
  description = "List of environment names to create"
}

variable "repositories" {
  type        = list(string)
  description = "List of repository names"
}

variable "repository_names" {
  type        = map(string)
  description = "Map of repository names"
} 